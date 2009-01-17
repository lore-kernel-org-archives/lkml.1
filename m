Return-Path: <linux-kernel-owner+w=401wt.eu-S1764133AbZAQQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764133AbZAQQMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbZAQQMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:12:02 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:22281 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759576AbZAQQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:12:00 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2009 11:12:00 EST
X-BigFish: VPS-60(z21eWz1432R62a3L98dR936eQ1805M179dRzzzzz32i6bh43j)
X-WSS-ID: 0KDMHM8-04-01Q-01
Date: Sat, 17 Jan 2009 16:56:35 +0100
From: Robert Richter <robert.richter@amd.com>
To: Tim Blechmann <tim@klingt.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
Message-ID: <20090117155635.GC21604@erda.amd.com>
References: <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain> <1231957184.13033.70.camel@thinkpad> <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain> <1232010853.6541.4.camel@thinkpad> <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain> <1232067181.6134.74.camel@thinkpad> <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain> <1232199169.7016.12.camel@thinkpad> <20090117141453.GA21604@erda.amd.com> <1232204963.17299.8.camel@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1232204963.17299.8.camel@thinkpad>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2009 15:56:35.0787 (UTC) FILETIME=[2CD151B0:01C978BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.01.09 16:09:23, Tim Blechmann wrote:
> > > however, trying to apply this patch to 2.6.28, the behavior is the same
> > > as before (one NMI) ... so possibly, it is a combination of two bugs,
> > > with similar symptoms ... 
> > 
> > Tim, could you revert 7c64ade53a6f977d73f16243865c42ceae999aea too?
> > 
> > If this not helps, last chance is
> > 59512900baab03c5629f2ff5efad1d5d4e682ece, but this seems to be save.
> 
> i tried to revert both commits, however the behavior doesn't seem to
> change. will try to apply the working patch to the child commits, maybe
> i can find something interesting ...

Hmm, strange. Actually 7c64ade53a6f977d73f16243865c42ceae999aea fixed
a similiar bug, see here:
http://bugzilla.kernel.org/show_bug.cgi?id=11908

Your patch with 2.6.28, does:

 grep NMI /proc/interrupts

returns exactly 1 NMI per core or some more?

> 
> best, tim
> 
> btw, i am not very familiar with kernel programming, but is it safe to
> have `static u64 *reset_value' uninitialized, or should it be
> initialized to NULL?

External and static variables should be gaaranteed to be initialized
to zero. Only local variables are uninitialized.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

