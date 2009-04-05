Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZDELzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZDELzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 07:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZDELzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 07:55:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7685 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZDELzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=TIC2PaDQdGqPikksthMnWEOwJnXzLdhN1v3LZ36hnl067vge2k63fzjzu5B2PvjfPZ
         MdlEK12DFxrS7Syq586H631dARi2pidot2Ig+1bL1LbX88ZtVxl4y+Tu2zfGQJLxptUS
         22J11oD4GsNDn1FT8taQc66hbL15Ctv3dcy/E=
Message-ID: <49D89C06.1060700@gmail.com>
Date: Sun, 05 Apr 2009 04:54:46 -0700
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
References: <20090324150517.GX27476@kernel.dk> <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com> <20090325152751.GV27476@kernel.dk> <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com> <20090326084205.GG27476@kernel.dk> <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com> <20090331104933.GJ5178@kernel.dk> <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com> <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com> <20090405012839.GF7553@mit.edu>
In-Reply-To: <20090405012839.GF7553@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2009 06:28 PM, Theodore Tso wrote:
> On Sat, Apr 04, 2009 at 11:20:35AM -0400, Ric Wheeler wrote:
>    
>> Barriers do work as we have them, but as others have mentioned, it is
>> not a "free" win - fsync will actually move your data safely out to
>> persistent storage for a huge percentage of real users (including every
>> ATA/S-ATA and SAS drive I was able to test).  The file systems I
>> monitored in production use without barriers were much less reliable.
>>      
>
> The problem is that, as long as you're not under memory pressure, and
> not pushing the filesystem heavily, ext3 didn't corrupt *that* often
> without barriers.  So people got away with it "most of the time" ---
> just as applications replacing files by rewriting them in place using
> truncate and w/o fsync would "usually" not lose data after a crash if
> they were using ext3 with data=ordered mode.  This caused people to
> get lazy/sloppy.
>
> So yes, barriers were something that were largely ignored for a long
> time.  After all, in a server environment with UPS's, without crappy
> proprietary video drivers, Linux systems didn't crash that often
> anyway.  So you really needed a large base of systems and with the
> ability to root cause failures such as what Ric had at EMC to see the
> problem.
>    

One thing to point out here is that there are a lot of "servers" in high 
end data centers that do not have UPS backup. Those racks full of 1U and 
2U boxes that are used to make "grids", "clouds" and so on often are 
built with as much gear as you can stuff in a rack - no batteries or UPS 
to be seen, so they are really quite similar to the normal desktop or 
home systems that we normally run at home :-)

ric


> Even now, the reason why ext3 doesn't have barriers enabled by default
> (although we did make them the default for ext4) is because Andrew
> doesn't believe Chris's replication case is likely to be true for most
> users in practice, and he's concerned about the performance
> degradation of barriers.  He's basically depending on the fact that
> "usually" you can get away without using barriers.  Sigh....
>
> 						- Ted
>
> P.S.  Of course, distributions should feel free to consider changing
> the default on their kernels.  SLES has already if memory serves
> correctly.  I don't know if RHEL has yet.
>
>
>    




