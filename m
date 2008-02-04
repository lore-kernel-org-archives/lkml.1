Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYBDXia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYBDXia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYBDXiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:38:21 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:45020 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYBDXiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:38:21 -0500
Message-ID: <47A7A131.8040800@qualcomm.com>
Date: Mon, 04 Feb 2008 15:35:13 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>
Subject: CPU hotplug and IRQ affinity with 2.6.24-rt1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just an FYI. As part of the "Isolated CPU extensions" thread Daniel suggest for me
to check out latest RT kernels. So I did or at least tried to and immediately spotted a couple
of issues.

The machine I'm running it on is:
	HP xw9300, Dual Opteron, NUMA

It looks like with -rt kernel IRQ affinity masks are ignored on that system. ie I write 1 to 
lets say /proc/irq/23/smp_affinity but the interrupts keep coming to CPU1. 
Vanilla 2.6.24 does not have that issue.

Also the first thing I tried was to bring CPU1 off-line. Thats the fastest way to get irqs, 
soft-irqs, timers, etc of a CPU. But the box hung completely. It also managed to mess up my 
ext3 filesystem to the point where it required manual fsck (have not see that for a couple of
years now). 
I tried the same thing (ie echo 0 > /sys/devices/cpu/cpu1/online) from the console. It hang 
again with the message that looked something like:
	CPU1 is now off-line
	Thread IRQ-23 is on CPU1 ...

IRQ 23 is NVidia SATA. So I guess it has something to do with the borked affinity handling.
Vanilla 2.6.24 handles this just fine.

Anyway, like I said it's just an FYI, not an urgent issue.

Max

