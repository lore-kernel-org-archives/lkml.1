Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXLBMey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXLBMey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXLBMef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:34:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3198 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752313AbXLBMed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:34:33 -0500
Date: Sat, 1 Dec 2007 08:33:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: suspend-related lockdep warning
Message-ID: <20071201083343.GA4446@ucw.cz>
References: <20071128024355.5931c6ec.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128024355.5931c6ec.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 2.6.24-rc3-mm2 (which will be released if it boots on two more machines and
> if I stay awake) will say this during suspend-to-RAM on the Vaio:
> 
> [   91.876445] Syncing filesystems ... done.
> [   92.382595] Freezing user space processes ... WARNING: at kernel/lockdep.c:2662 check_flags()
> [   92.384000] Pid: 1925, comm: dbus-daemon Not tainted 2.6.24-rc3-mm2 #32
> [   92.384177]  [<c0104a74>] show_trace_log_lvl+0x12/0x25
> [   92.384335]  [<c01052ff>] show_trace+0xd/0x10
> [   92.384469]  [<c01059be>] dump_stack+0x55/0x5d
> [   92.384605]  [<c0136a29>] check_flags+0x7f/0x11a
> [   92.384746]  [<c0139cfb>] lock_acquire+0x3a/0x86
> [   92.384886]  [<c031f4de>] _spin_lock+0x26/0x53
> [   92.385023]  [<c0141d3b>] refrigerator+0x13/0xc8
> [   92.385163]  [<c01274c8>] get_signal_to_deliver+0x32/0x3fb
> [   92.385326]  [<c01030f4>] do_notify_resume+0x8c/0x699
> [   92.385476]  [<c0103c18>] work_notifysig+0x13/0x1b
> [   92.385620]  =======================
> [   92.385719] irq event stamp: 309
> [   92.385809] hardirqs last  enabled at (309): [<c0103c79>] syscall_exit_work+0x11/0x26
> [   92.386045] hardirqs last disabled at (308): [<c0103b42>] syscall_exit+0x14/0x25
> [   92.386265] softirqs last  enabled at (0): [<c011bea5>] copy_process+0x374/0x130e
> [   92.386491] softirqs last disabled at (0): [<00000000>] 0x0
> [   92.392457] (elapsed 0.00 seconds) done.
> [   92.392581] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [   92.392882] PM: Entering mem sleep
> [   92.392974] Suspending console(s)
> 
> this has been happening for quite some time and might even be happening in
> mainline.  

Is it complaining that we entered refrigerator with irqs disabled?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
