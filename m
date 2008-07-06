Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbYGFUo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbYGFUo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYGFUoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:44:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:44124 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbYGFUoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bWLNKervRWiG6Fqu3byZOssOu2ci5u8Wr+Rb98SCV8J0D8xlQiHUj95NJ9p2VEFQPP
         CGifMAghw6Vro58co6FDBIi2e06ocW2NeOfy8JKh0+LrmgxZYogVeS/90hRdrDDr3w1C
         z20FXAucCDnec7hQ89HF9JkgLnBssaRDGPVc0=
Message-ID: <9871ee5f0807061344u155db848r96863535eb00f3ce@mail.gmail.com>
Date: Sun, 6 Jul 2008 16:44:16 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: HELP: Getting unexpected fakeraid behavior. Fix?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080706131937.13065312@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
	 <20080706131937.13065312@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 4:19 PM, Arjan van de Ven <arjan@infradead.org> wrote:

>> Since RAID1 is a mirrored configuration, it's possible to distribute
>> reads across the drives, improving throughput and latency over a
>> single drive on random reads.
>
> This is.. borderline true. Let me explain the caveats;
> for a SINGLE THREADED workload, there is actually no difference.
> Balancing long sequential reads over the 2 disks isn't such a good idea
> for that case, since it just introduces seeks rather than keep up with
> the streaming speed.
> Balancing seeks; there might be some theoretical advantage because you
> could, again in theory, do shorter seeks if you keep one head at the
> inside and one the other disk head on the outside. In practice... a lot
> of the seek time is rotational latency so it's not as big a deal as it
> may sound; the moment you seek you pay a ton.

Ok, I see.  This makes sense.  It is a single thread.  I did kindof
expect that since the spatial locality of the metadata and files
themselves (thousands of 2K byte files being read in a different order
from which they were created) should not be very good, the kernel
would round-robin (or probably something better) the requests (single
blocks and sequential groups of blocks) between drives.

So, if I were to divide these reads across multiple threads, I would
see requests to both drives?  I'm wondering now if that would really
help, although as far as I can tell, what I'm doing is dominated by
seek time.

And the kernel pays attention to which thread caused a given request?
What if you have two threads alternatively reading one file?  (Which
would obviously have to be serialized by locks.)  Just curious.  :)

> if your application is single threaded this isn't totally unexpected as
> a result...


Oh, and one other question.  I know the drives are AHCI capable, and
when I read the drive flags, they report that it's enabled, and that
the queue depth is 31.  For the controller, the BIOS has three
settings, IDE, AHCI, and RAID.  In IDE mode, NCQ and other AHCI
features are disabled.  Unfortunately, the BIOS and manual for the
motherboard do not state that AHCI features are enabled in RAID mode.
Is there a way I can query to kernel to see if it's actually USING
NCQ?

The reason I'm on about this is that the workloads I'm throwing at
this computer are (sometimes) badly bottlenecked by the disks, so if I
can get better throughput, that would help a lot.

Thank you for your help.


-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
