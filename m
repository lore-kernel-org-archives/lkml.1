Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZC3T0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZC3T0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZC3T0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:26:34 -0400
Received: from main.gmane.org ([80.91.229.2]:45332 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZC3T0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:26:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 2/2] Make relatime default
Date: Mon, 30 Mar 2009 15:26:10 -0400
Message-ID: <gqr6ci$afs$1@ger.gmane.org>
References: <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk> <20090330144213.GA5426@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-70-109-119-176.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <20090330144213.GA5426@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Thu, Mar 26, 2009 at 06:48:38PM +0000, Alan Cox wrote:
>> On Thu, 26 Mar 2009 17:53:14 +0000
>> Matthew Garrett <mjg@redhat.com> wrote:
>>
>>> Change the default behaviour of the kernel to use relatime for all
>>> filesystems. This can be overridden with the "strictatime" mount
>>> option.
>> NAK this again
> 
> NAK but because if we change the default it is better to change it to
> the real thing: noatime.
> 
> I think this can be solved in userland but perhaps changing this in
> kernel would be a stronger message that atime is officially
> obsoleted. (and nothing will break, not even mutt users will notice,
> and if they really do it won't be anything more than aesthetical)
> 
This makes the assumption that atime is not used, which may be true on your 
system but isn't on others. I regularly move data between faster and slower 
storage based on atime, and promote reactivated projects to something faster, 
while retiring inactive project data elsewhere. Other admins use it to identify 
unused files which are candidates for backup to offline media or the bit bucket.

Let people who want that behavior specify it for existing filesystems, if you 
want to remove functionality from ext4 or btrfs or some thing place where people 
have no existing expectations, I still think it's wrong, but I couldn't say I 
think it might break anything.

I did a patch a few years ago which only updated atime on open and write, and 
that worked about as well as relatime, the inode update on open is cheap, the 
head is already there, and it was only slightly slower than noatime. The were no 
programs which kept files open for days and just read them. The the only storage 
hierarchy was "slow and cheap." ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

