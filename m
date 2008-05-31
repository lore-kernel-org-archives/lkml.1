Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYEaPMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYEaPMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYEaPLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:11:52 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:48688 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYEaPLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:11:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet transmit
Date: Sat, 31 May 2008 17:11:15 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
In-Reply-To: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805311711.16266.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2008 16:23:58 Stefanik Gábor wrote:
> In the latest wireless-testing kernel, I get a panic when I try to
> connect to a network or inject a packet in monitor mode using b43
> (stack obtained using kdump and crash):
> 
> crash> bt -l
> PID: 0      TASK: c0431340  CPU: 0   COMMAND: "swapper"
>  #0 [c04617bc] crash_kexec at c015ce2a
>     /usr/src/wl-hack/wireless-testing/kernel/kexec.c: 1077
>  #1 [c046180c] die at c01054ba
>     /usr/src/wl-hack/wireless-testing/arch/x86/kernel/traps_32.c: 476
>  #2 [c0461828] do_page_fault at c034ef1f
>     /usr/src/wl-hack/wireless-testing/arch/x86/mm/fault.c: 858
>  #3 [c0461994] error_code (via page_fault) at c034d2e8
>     /usr/src/wl-hack/wireless-testing/arch/i386/kernel/entry.S
>     EAX: 00000000  EBX: 00000000  ECX: f6103000  EDX: f75ed4a0  EBP: c0461a58
>     DS:  007b      ESI: 00000002  ES:  007b      EDI: 00000074
>     CS:  0060      EIP: f8dd3a99  ERR: ffffffff  EFLAGS: 00010046
>  #4 [c04619c8] b43_generate_txhdr at f8dd3a99
>  #5 [c0461a5c] b43_dma_tx at f8dd83d7
>  #6 [c0461ae4] b43_op_tx at f8dc4d32
>  #7 [c0461afc] __ieee80211_tx at f89c3ed4
>  #8 [c0461b14] ieee80211_master_start_xmit at f89c4b6d
>  #9 [c0461b74] dev_hard_start_xmit at c02d4cb5
>     /usr/src/wl-hack/wireless-testing/net/core/dev.c: 1558
> #10 [c0461ba0] __qdisc_run at c02e678d
>     /usr/src/wl-hack/wireless-testing/net/sched/sch_generic.c: 155
> #11 [c0461bd8] dev_queue_xmit at c02d5172
>     include/net/pkt_sched.h: 89
> #12 [c0461c04] ieee80211_subif_start_xmit at f89c45db
> #13 [c0461cc0] dev_hard_start_xmit at c02d4cb5
>     /usr/src/wl-hack/wireless-testing/net/core/dev.c: 1558
> #14 [c0461cec] __qdisc_run at c02e678d
>     /usr/src/wl-hack/wireless-testing/net/sched/sch_generic.c: 155
> #15 [c0461d24] dev_queue_xmit at c02d5172
>     include/net/pkt_sched.h: 89
> #16 [c0461d50] neigh_resolve_output at c02dac3e
>     /usr/src/wl-hack/wireless-testing/net/core/neighbour.c: 1215
> #17 [c0461d90] ip6_output_finish at f8d55c9e
> #18 [c0461db0] ip6_output2 at f8d57e63
> #19 [c0461dd4] ip6_output at f8d58418
> #20 [c0461e50] mld_sendpack at f8d70d8d
> #21 [c0461ebc] mld_ifc_timer_expire at f8d71a94
> #22 [c0461ef0] run_timer_softirq at c0138547
>     /usr/src/wl-hack/wireless-testing/kernel/timer.c: 798
> #23 [c0461f34] __do_softirq at c0134230
>     /usr/src/wl-hack/wireless-testing/kernel/softirq.c: 234
> #24 [c0461f50] do_softirq at c0134318
>     /usr/src/wl-hack/wireless-testing/kernel/softirq.c: 271
> #25 [c0461f5c] irq_exit at c01344b0
>     /usr/src/wl-hack/wireless-testing/kernel/softirq.c: 310
> #26 [c0461f64] smp_apic_timer_interrupt at c0113583
>     /usr/src/wl-hack/wireless-testing/arch/x86/kernel/apic_32.c: 619
> #27 [c0461f7c] apic_timer_interrupt at c0104963
>     include/linux/kdev_t.h: 52
> #28 [c0461fbc] cpu_idle at c0102d69
>     /usr/src/wl-hack/wireless-testing/arch/x86/kernel/process_32.c: 188
> 
> No out-of-tree patches applied on b43. (I used to have a patch
> applied, but I removed it to test reproducibility of this crash.)
> 
> Any ideas why this happens?

Please provide more information. For example as for what "crash" means.
Is this a NULL pointer dereference or whatever?
Please put a few printks into b43_generate_txhdr()


-- 
Greetings Michael.
