Return-Path: <linux-kernel-owner+w=401wt.eu-S1161055AbXAaVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161055AbXAaVx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161057AbXAaVx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:53:28 -0500
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:54181 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161055AbXAaVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:53:27 -0500
Date: Wed, 31 Jan 2007 22:52:41 +0100
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070131215241.GB2890@inferi.kami.home>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
References: <20070129204528.eb8d695e.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.20-rc2-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 08:45:28PM -0800, Andrew Morton wrote:
> 
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm3/
> 
> Will appear later at
> 
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/

I jumped from rc2-mm1 to rc6-mm3 and tried dynticks for the first time:

...
Time: acpi_pm clocksource has been installed.
Clocksource tsc unstable (delta = -275154141 ns)
BUG: soft lockup detected on CPU#1!
 [<c0104dac>] show_trace_log_lvl+0x1a/0x2f
 [<c010540b>] show_trace+0x12/0x14
 [<c010548f>] dump_stack+0x16/0x18
 [<c0146e50>] softlockup_tick+0xa7/0xb6
 [<c01286c0>] run_local_timers+0x12/0x14
 [<c0128a61>] update_process_times+0x3e/0x63
 [<c01374c5>] tick_nohz_handler+0x7d/0xe3
 [<c01137c2>] smp_apic_timer_interrupt+0x71/0x83
 [<c01048f4>] apic_timer_interrupt+0x28/0x30
 [<c013709e>] tick_broadcast_oneshot_control+0x12/0xc8
 [<c0136a58>] tick_notify+0x1cd/0x241
 [<c012bd4e>] notifier_call_chain+0x2b/0x55
 [<c012bde2>] __raw_notifier_call_chain+0x19/0x1e
 [<c012be01>] raw_notifier_call_chain+0x1a/0x1c
 [<c01364ea>] clockevents_do_notify+0x11/0x13
 [<c013672d>] clockevents_notify+0x1c/0x53
 [<f8f7b5cb>] acpi_state_timer_broadcast+0x2e/0x31 [processor]
 [<f8f7c12f>] acpi_processor_idle+0x276/0x40b [processor]
 [<c0102435>] cpu_idle+0xad/0xd3
 [<c0112975>] start_secondary+0x32b/0x333
 [<00000000>] run_init_process+0x3fefed10/0x19
 =======================

Full dmesg and config:
http://oioio.altervista.org/linux/nohz_soft-lockup.dmesg
http://oioio.altervista.org/linux/config-2.6.20-rc6-mm3-1

As a side note the process becomes slower and slower as it proceeds,
it's definitely noticeable during my iptables rules setup (nothing that
complex, just default policies and subnet/lan accept rules).
Building with NO_HZ=n right now.

-- 
mattia
:wq!
