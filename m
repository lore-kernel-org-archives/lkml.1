Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbXA2LCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbXA2LCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXA2LCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:02:39 -0500
Received: from twin.jikos.cz ([213.151.79.26]:49075 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbXA2LCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:02:38 -0500
Date: Mon, 29 Jan 2007 12:02:15 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20-rc6-mm2
In-Reply-To: <20070129001207.71ea3470.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701291122570.9448@twin.jikos.cz>
References: <20070129001207.71ea3470.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Andrew Morton wrote:

> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm2/

I just got this on suspend/resume cycle on my IBM T42p

pcspkr pcspkr: EARLY resume
vesafb vesafb.0: EARLY resume
serial8250 serial8250: EARLY resume
i8042 i8042: EARLY resume
platform floppy.0: EARLY resume
BUG: soft lockup detected on CPU#0!
 [<c01043ae>] show_trace_log_lvl+0x1a/0x2f
 [<c0104941>] show_trace+0x12/0x14
 [<c01049c5>] dump_stack+0x16/0x18
 [<c0142053>] softlockup_tick+0x93/0xa2
 [<c011eb5b>] run_local_timers+0x12/0x14
 [<c011ed6f>] update_process_times+0x36/0x5a
 [<c012c567>] tick_periodic+0x66/0x72
 [<c012c580>] tick_handle_periodic+0xd/0x3d
 [<c0105d6a>] timer_interrupt+0xe/0x15
 [<c0142310>] handle_IRQ_event+0x1a/0x46
 [<c01435ac>] handle_level_irq+0x7c/0xc4
 [<c0105300>] do_IRQ+0x82/0x9e
 [<c0103f6e>] common_interrupt+0x2e/0x34
 [<c013a78e>] snapshot_ioctl+0x1e7/0x581
 [<c016bc1d>] do_ioctl+0x41/0x51
 [<c016be2d>] vfs_ioctl+0x200/0x217
 [<c016be8d>] sys_ioctl+0x49/0x64
 [<c0103cf8>] sysenter_past_esp+0x5d/0x99
 =======================
platform dock.0: resuming
acpi acpi_system:00: resuming
acpi button_power:00: resuming
ACPI Processor Driver processor:00: resuming

I guess that it's caused by some timer changes (added Thomas and Ingo to 
CC), which confuse the softlockup detector sense of time? 

-- 
Jiri Kosina
