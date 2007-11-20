Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXKTATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXKTATT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXKTATL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:19:11 -0500
Received: from mailout03.sul.t-online.de ([194.25.134.81]:37518 "EHLO
	mailout03.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbXKTATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:19:10 -0500
Message-ID: <474227F9.8050909@t-online.de>
Date: Tue, 20 Nov 2007 01:19:05 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.23.8, ondemand scaling governor: "BUG: soft lockup detected on
 CPU#0!"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: JbOeGkZLwhnbOILr1z9oRjZOS658U0+wnvDTTaFSmw1SGm1rCGOWJ34c7F5a8CogfS
X-TOI-MSGID: 4e4eb20a-1783-4a4e-bbd7-3f5b35d96d7d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

using the ondemand scaling governour I see some error messages
in kern.log, e.g.:

Nov 20 01:00:46 bugs kernel: BUG: soft lockup detected on CPU#0!
Nov 20 01:00:46 bugs kernel:  [<c013cf8d>] softlockup_tick+0x91/0xa6
Nov 20 01:00:46 bugs kernel:  [<c012269c>] update_process_times+0x3a/0x5d
Nov 20 01:00:46 bugs kernel:  [<c0131219>] tick_sched_timer+0x115/0x164
Nov 20 01:00:46 bugs kernel:  [<c012d311>] hrtimer_interrupt+0x102/0x191
Nov 20 01:00:46 bugs kernel:  [<c0106cd6>] timer_interrupt+0x2e/0x34
Nov 20 01:00:46 bugs kernel:  [<c013d1f6>] handle_IRQ_event+0x1a/0x3f
Nov 20 01:00:46 bugs kernel:  [<c013e4e1>] handle_level_irq+0xa8/0xb7
Nov 20 01:00:46 bugs kernel:  [<c0106367>] do_IRQ+0x53/0x6c
Nov 20 01:00:46 bugs kernel:  [<c0104853>] common_interrupt+0x23/0x28
Nov 20 01:00:46 bugs kernel:  [<c011007b>] smp_apic_timer_interrupt+0x1a/0x70
Nov 20 01:00:46 bugs kernel:  [<c0102a36>] default_idle+0x27/0x39
Nov 20 01:00:46 bugs kernel:  [<c010234c>] cpu_idle+0x46/0x68
Nov 20 01:00:46 bugs kernel:  [<c032e9e8>] start_kernel+0x24d/0x252
Nov 20 01:00:46 bugs kernel:  [<c032e317>] unknown_bootoption+0x0/0x196
Nov 20 01:00:46 bugs kernel:  =======================

This seems to happen when the load drops below the threshold and
the ondemand governor changes the CPU from 2GHz to 400MHz. If I use
the "performance" governor instead, then there is no such message.
If I set it back to "ondemand", then the message is printed
immediately.

# uname -a
Linux bugs 2.6.23.8 #1 PREEMPT Sun Nov 18 09:14:13 CET 2007 i686 GNU/Linux
# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 2.00GHz
stepping        : 8
cpu MHz         : 400.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx bts est tm2
bogomips        : 798.34
clflush size    : 64


Please mail if I can help to track this down.


Regards

Harri
