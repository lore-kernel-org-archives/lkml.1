Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbXFET1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbXFET1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbXFET1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:27:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765382AbXFET07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:26:59 -0400
Date: Tue, 5 Jun 2007 12:26:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Linux 2.6.22-rc4
In-Reply-To: <4665B169.2030803@googlemail.com>
Message-ID: <alpine.LFD.0.98.0706051219560.4921@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
 <4665B169.2030803@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jun 2007, Michal Piotrowski wrote:
> 
> It is too stable for me.

I wish all our testers were you ;)

> this looks harmless
> 
> [  116.733327] PM: suspend-to-disk mode set to 'shutdown'
> [  116.738849] swsusp: Basic memory bitmaps created
> [  116.745353] Stopping tasks ... WARNING: at /home/devel/linux-git/kernel/lockdep.c:2414 check_flags()
> [  116.754921]  [<c0404fbf>] show_trace_log_lvl+0x1a/0x2f
> [  116.754937]  [<c0405bd6>] show_trace+0x12/0x14
> [  116.754947]  [<c0405c5d>] dump_stack+0x16/0x18
> [  116.754957]  [<c043c3e5>] check_flags+0x95/0x143
> [  116.754967]  [<c043f158>] lock_acquire+0x29/0x82
> [  116.754977]  [<c06313a7>] _spin_lock+0x35/0x42
> [  116.754990]  [<c044894a>] refrigerator+0x14/0xc6
> [  116.755002]  [<c042d4b3>] get_signal_to_deliver+0x33/0x397
> [  116.755016]  [<c0403597>] do_notify_resume+0x94/0x6ed
> [  116.755029]  [<c0404099>] work_notifysig+0x13/0x1a
> [  116.755044]  =======================
> [  116.755052] irq event stamp: 69
> [  116.755060] hardirqs last  enabled at (69): [<c04040f9>] syscall_exit_work+0x11/0x26
> [  116.755084] hardirqs last disabled at (68): [<c0403fdd>] syscall_exit+0x9/0x1a
> [  116.755109] softirqs last  enabled at (0): [<c042150c>] copy_process+0x4dd/0x1286
> [  116.755139] softirqs last disabled at (0): [<00000000>] 0x0
> [  116.945776] done.
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4/git-dmesg
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4/git-config

Well, it's harmless in the sense that "yeah, the system still works", but 
it does seem to be a real bug. We have hardware interrupts disabled when 
we _think_ we should have them on, so our irq tracking is off.

Ingo, do you see what's up? It looks like we got a signal to a process 
that just got created, is the setup stuff for "tsk->hardirqs_enabled" 
perhaps off a bit?

			Linus
