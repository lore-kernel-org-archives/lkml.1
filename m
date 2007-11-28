Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXK1VtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXK1VtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXK1Vs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:48:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbXK1Vsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:48:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: suspend-related lockdep warning
Date: Wed, 28 Nov 2007 23:06:45 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
References: <20071128024355.5931c6ec.akpm@linux-foundation.org>
In-Reply-To: <20071128024355.5931c6ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711282306.46712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 of November 2007, Andrew Morton wrote:
> 
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

I guess this is the task_lock() in refrigerator().

If that is the case, I don't understand this trace at all.

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
> 
> Also, a few seconds after resume has completed we get a whimper from the
> hangcheck driver:
> 
> [    1.762425] usb 2-1: configuration #1 chosen from 1 choice
> [    1.826548] input: Microsoft Microsoft Wireless Optical Mouse_ 1.00 as /class/input/input9
> [    1.866211] input: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse_ 1.00] on usb-0000:00:1d.1-1
> [    5.757927] Hangcheck: hangcheck value past margin!
