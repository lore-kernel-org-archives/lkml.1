Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZKLQ0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZKLQ0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZKLQ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:26:06 -0500
Received: from lucidpixels.com ([75.144.35.66]:36956 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbZKLQ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:26:05 -0500
Date: Thu, 12 Nov 2009 11:26:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dave Jones <davej@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan> <20091111195016.GB22225@redhat.com> <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, Justin Piszcz wrote:

> Hi,

Any other clues/things to try to find out why this is happening?

Here is the dmesg from Phoronix but they are using an i750 not an i870, 
the only differences that I can note are below:
http://www.phoronix.com/scan.php?page=article&item=intel_p55&num=3

Phoronix:
[ 0.468994] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[ 0.468999] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[ 0.472841] hpet: hpet2 irq 24 for MSI
[ 0.473257] hpet: hpet3 irq 25 for MSI
[ 0.477260] hpet: hpet4 irq 26 for MSI
[ 0.481251] hpet: hpet5 irq 27 for MSI

My host:
[    0.656054] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[    0.656060] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.659020] hpet: hpet2 irq 24 for MSI
[    0.659253] hpet: hpet3 irq 25 for MSI
[    0.659993] hpet: hpet4 irq 26 for MSI
[    0.660317] hpet: hpet5 irq 27 for MSI
[    0.661001] hpet: hpet6 irq 28 for MSI

Much of their dmesg is the same as mine with the exception of the of the 
problem I am reporting, what is the best way to debug this problem 
further?

Perhaps the Phoronix configuration does not have processor loaded in the 
kernel or as a module?

Again, the problem:
[    3.318770] cpuidle: using governor ladder
[    3.321556] ------------[ cut here ]------------
[    3.321560] WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x70/0x80()
[    3.321561] Hardware name:
[    3.321562] Modules linked in:
[    3.321564] Pid: 0, comm: swapper Not tainted 2.6.31.5 #17
[    3.321565] Call Trace:
[    3.321567]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
[    3.321568]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
[    3.321571]  [<ffffffff81056724>] ? warn_slowpath_common+0x74/0xd0
[    3.321573]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
[    3.321576]  [<ffffffff81077696>] ? tick_dev_program_event+0x36/0xb0
[    3.321578]  [<ffffffff81077079>] ? tick_broadcast_oneshot_control+0x119/0x120
[    3.321579]  [<ffffffff8107683d>] ? tick_notify+0x22d/0x420
[    3.321581]  [<ffffffff8106fe37>] ? notifier_call_chain+0x37/0x70
[    3.321583]  [<ffffffff8107612b>] ? clockevents_notify+0x2b/0x90
[    3.321586]  [<ffffffff81244848>] ? acpi_idle_enter_bm+0x15f/0x2d3
[    3.321587]  [<ffffffff812446de>] ? acpi_idle_enter_c1+0xf1/0xfc
[    3.321590]  [<ffffffff812e6d7a>] ? cpuidle_idle_call+0xba/0x120
[    3.321593]  [<ffffffff8102b832>] ? cpu_idle+0x62/0xc0
[    3.321596] ---[ end trace cac202f11005305c ]---
[    3.553852] cpuidle: using governor menu

Justin.



