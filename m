Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXKTBBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXKTBBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXKTBBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:01:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:38872 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbXKTBBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:01:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,438,1188802800"; 
   d="scan'208";a="210907250"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.8, ondemand scaling governor: "BUG: soft lockup detected on CPU#0!"
Date: Mon, 19 Nov 2007 17:01:11 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE251A40@orsmsx423.amr.corp.intel.com>
In-Reply-To: <474227F9.8050909@t-online.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.8, ondemand scaling governor: "BUG: soft lockup detected on CPU#0!"
Thread-Index: AcgrC1DSnRFMcEbnTBaXEUfY3PCn/wABWHHg
References: <474227F9.8050909@t-online.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Harald Dunkel" <harald.dunkel@t-online.de>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Nov 2007 01:01:02.0967 (UTC) FILETIME=[D269A870:01C82B10]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Harald Dunkel
>Sent: Monday, November 19, 2007 4:19 PM
>To: Linux Kernel list
>Subject: 2.6.23.8, ondemand scaling governor: "BUG: soft 
>lockup detected on CPU#0!"
>
>Hi folks,
>
>using the ondemand scaling governour I see some error messages
>in kern.log, e.g.:
>
>Nov 20 01:00:46 bugs kernel: BUG: soft lockup detected on CPU#0!
>Nov 20 01:00:46 bugs kernel:  [<c013cf8d>] softlockup_tick+0x91/0xa6
>Nov 20 01:00:46 bugs kernel:  [<c012269c>] 
>update_process_times+0x3a/0x5d
>Nov 20 01:00:46 bugs kernel:  [<c0131219>] tick_sched_timer+0x115/0x164
>Nov 20 01:00:46 bugs kernel:  [<c012d311>] 
>hrtimer_interrupt+0x102/0x191
>Nov 20 01:00:46 bugs kernel:  [<c0106cd6>] timer_interrupt+0x2e/0x34
>Nov 20 01:00:46 bugs kernel:  [<c013d1f6>] handle_IRQ_event+0x1a/0x3f
>Nov 20 01:00:46 bugs kernel:  [<c013e4e1>] handle_level_irq+0xa8/0xb7
>Nov 20 01:00:46 bugs kernel:  [<c0106367>] do_IRQ+0x53/0x6c
>Nov 20 01:00:46 bugs kernel:  [<c0104853>] common_interrupt+0x23/0x28
>Nov 20 01:00:46 bugs kernel:  [<c011007b>] 
>smp_apic_timer_interrupt+0x1a/0x70
>Nov 20 01:00:46 bugs kernel:  [<c0102a36>] default_idle+0x27/0x39
>Nov 20 01:00:46 bugs kernel:  [<c010234c>] cpu_idle+0x46/0x68
>Nov 20 01:00:46 bugs kernel:  [<c032e9e8>] start_kernel+0x24d/0x252
>Nov 20 01:00:46 bugs kernel:  [<c032e317>] unknown_bootoption+0x0/0x196
>Nov 20 01:00:46 bugs kernel:  =======================
>
>This seems to happen when the load drops below the threshold and
>the ondemand governor changes the CPU from 2GHz to 400MHz. If I use
>the "performance" governor instead, then there is no such message.
>If I set it back to "ondemand", then the message is printed
>immediately.
>
># uname -a
>Linux bugs 2.6.23.8 #1 PREEMPT Sun Nov 18 09:14:13 CET 2007 
>i686 GNU/Linux
># cat /proc/cpuinfo
>processor       : 0
>vendor_id       : GenuineIntel
>cpu family      : 6
>model           : 13
>model name      : Intel(R) Pentium(R) M processor 2.00GHz
>stepping        : 8
>cpu MHz         : 400.000
>cache size      : 2048 KB
>fdiv_bug        : no
>hlt_bug         : no
>f00f_bug        : no
>coma_bug        : no
>fpu             : yes
>fpu_exception   : yes
>cpuid level     : 2
>wp              : yes
>flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr 
>pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe 
>nx bts est tm2
>bogomips        : 798.34
>clflush size    : 64
>
>
>Please mail if I can help to track this down.
>
>

Can you try switching to powersave governor (which should always run CPU
at 400MHz) and see whether you see similar error?

Thanks,
Venki
