Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYA0Afo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYA0Afo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 19:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYA0Afg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 19:35:36 -0500
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:39824 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbYA0Aff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 19:35:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAEZgm0ecIsJH/2dsb2JhbAAIq3w
Message-ID: <479BD1D1.8020503@gmail.com>
Date: Sat, 26 Jan 2008 20:35:29 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: X fails to start with latest Linus git
References: <479BCE03.6070603@gmail.com>
In-Reply-To: <479BCE03.6070603@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> Hi Ingo,
> 
> Starting X (autostarted with GDM) manages to lock up my system
> (requiring a hard reset) after the first few tree merges of the window,
> and bisection shows:
> 
> -----------------
> 
> 19ef9309273d26cb005cb23e6a370353dca91099 is first bad commit
> commit 19ef9309273d26cb005cb23e6a370353dca91099
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jan 25 21:08:34 2008 +0100
> 
>     printk: use ktime_get()
> 
>     printk timestamps: use ktime_get().
> 
>     Some platforms have a functioning clocksource function only after
>     they are done with early bootup, so delay this until out of
>     SYSTEM_BOOTING state.
> 
>     it's also inherently safe now, as any bugs in this area will be
>     caught by the printk recursion checks.
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> -----------------
> 
> as the first bad commit.  I have no idea why that would cause problems,
> so it could also be some timing-related problem that just happened to
> bisect to this patch.
> 
> I will try advancing to the head of Linus' tree and then reverting this
> patch to make sure it fixes the problem, but I figured I'd send this
> first to see if it is obvious to anyone.
> 

Yes, with this as my "git log" :

------------

commit 1814180093994543e8fbfd8d91f383081a9bc283
Author: Kevin Winchester <kevin@alekhine.(none)>
Date:   Sat Jan 26 20:21:44 2008 -0400

    Revert "printk: use ktime_get()"

    This reverts commit 19ef9309273d26cb005cb23e6a370353dca91099.

commit 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
Merge: 50d9a12... 23c3e29...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jan 25 17:19:08 2008 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6

    * git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6:
(200 commits)
      [SCSI] usbstorage: use last_sector_bug flag universally
      [SCSI] libsas: abstract STP task status into a function
      [SCSI] ultrastor: clean up inline asm warnings
      [SCSI] aic7xxx: fix firmware build
      [SCSI] aacraid: fib context lock for management ioctls
      [SCSI] ch: remove forward declarations
      [SCSI] ch: fix device minor number management bug
      [SCSI] ch: handle class_device_create failure properly
      [SCSI] NCR5380: fix section mismatch
      [SCSI] sg: fix /proc/scsi/sg/devices when no SCSI devices
      [SCSI] IB/iSER: add logical unit reset support
      [SCSI] don't use __GFP_DMA for sense buffers if not required
      [SCSI] use dynamically allocated sense buffer
      [SCSI] scsi.h: add macro for enclosure bit of inquiry data
      [SCSI] sd: add fix for devices with last sector access problems
      [SCSI] fix pcmcia compile problem
      [SCSI] aacraid: add Voodoo Lite class of cards.
      [SCSI] aacraid: add new driver features flags
      [SCSI] qla2xxx: Update version number to 8.02.00-k7.
      [SCSI] qla2xxx: Issue correct MBC_INITIALIZE_FIRMWARE command.
      ...

-------------

The machine boots normally, but without that revert, X locks up.  Does
that make sense to anyone?

-- 
Kevin Winchester


