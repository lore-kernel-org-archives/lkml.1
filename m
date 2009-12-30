Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZL3Th1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZL3Th1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZL3Th1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:37:27 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:42722 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZL3Th0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:37:26 -0500
Message-ID: <4B3BABF4.2060301@pardus.org.tr>
Date: Wed, 30 Dec 2009 21:37:24 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Disabling IRQ #20 problem with JMicron SATA-PATA Controller
References: <4B3B177E.60103@pardus.org.tr> <4B3BA9D9.10102@gmail.com>
In-Reply-To: <4B3BA9D9.10102@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>
> You say this only happens if the JMicron controller is enabled and set
> to AHCI mode? That's odd because it's the IRQ for the main Intel
> controller that it's complaining about. If that's really the IRQ it's
> using then I wonder how the system continues booting at all after it's
> disabled. Can you post /proc/interrupts output?
>
> My other suggestions would be make sure you have the latest BIOS
> installed, and try a newer kernel if possible..

I was wrong as the issue appears randomly even if the JMicron controller
is disabled. I've already updated to the latest BIOS.

Here's the /proc/interrupts output on a system which didn't complain yet
about the IRQ issue:

          CPU0       CPU1       CPU2       CPU3       CPU4      
CPU5       CPU6       CPU7
20:          0          0     208895          0          0         
0          0       3723   IO-APIC-fasteoi   ahci


I rechecked kern.log and observed that the trace differs in terms of the
handler function:

Dec 28 11:32:07 redd kernel: [   57.201100] Call Trace:
Dec 28 11:32:07 redd kernel: [   57.201108]  [<c01759cf>]
__report_bad_irq+0x2e/0x6f
Dec 28 11:32:07 redd kernel: [   57.201113]  [<c0175b00>]
note_interrupt+0xf0/0x148
Dec 28 11:32:07 redd kernel: [   57.201116]  [<c017601e>]
handle_fasteoi_irq+0x7d/0x9b
Dec 28 11:32:07 redd kernel: [   57.201122]  [<c0104cdb>]
handle_irq+0x3b/0x48
Dec 28 11:32:07 redd kernel: [   57.201126]  [<c0104648>] do_IRQ+0x40/0x83
Dec 28 11:32:07 redd kernel: [   57.201130]  [<c0103889>]
common_interrupt+0x29/0x30
Dec 28 11:32:07 redd kernel: [   57.201135]  [<c0108662>] ?
mwait_idle+0x6b/0x89
Dec 28 11:32:07 redd kernel: [   57.201139]  [<c01024b1>] cpu_idle+0x49/0x64
Dec 28 11:32:07 redd kernel: [   57.201145]  [<c03fde07>]
start_secondary+0xc6/0xc8
Dec 28 11:32:07 redd kernel: [   57.201148] handlers:
Dec 28 11:32:07 redd kernel: [   57.201149] [<f8076414>]
(ahci_interrupt+0x0/0xa8 [ahci])
Dec 28 11:32:07 redd kernel: [   57.201158] Disabling IRQ #20

--

Dec 30 09:35:30 redd kernel: [144782.793812] Call Trace:
Dec 30 09:35:30 redd kernel: [144782.793822]  [<c01759cf>]
__report_bad_irq+0x2e/0x6f
Dec 30 09:35:30 redd kernel: [144782.793827]  [<c0175b00>]
note_interrupt+0xf0/0x148
Dec 30 09:35:30 redd kernel: [144782.793830]  [<c017601e>]
handle_fasteoi_irq+0x7d/0x9b
Dec 30 09:35:30 redd kernel: [144782.793836]  [<c0104cdb>]
handle_irq+0x3b/0x48
Dec 30 09:35:30 redd kernel: [144782.793840]  [<c0104648>] do_IRQ+0x40/0x83
Dec 30 09:35:30 redd kernel: [144782.793844]  [<c0103889>]
common_interrupt+0x29/0x30
Dec 30 09:35:30 redd kernel: [144782.793849]  [<c0108662>] ?
mwait_idle+0x6b/0x89
Dec 30 09:35:30 redd kernel: [144782.793853]  [<c01024b1>]
cpu_idle+0x49/0x64
Dec 30 09:35:30 redd kernel: [144782.793859]  [<c03fde07>]
start_secondary+0xc6/0xc8
Dec 30 09:35:30 redd kernel: [144782.793862] handlers:
Dec 30 09:35:30 redd kernel: [144782.793863] [<f86c1eba>]
(ata_sff_interrupt+0x0/0xab [libata])
Dec 30 09:35:30 redd kernel: [144782.793895] [<f86c1eba>]
(ata_sff_interrupt+0x0/0xab [libata])
Dec 30 09:35:30 redd kernel: [144782.793919] Disabling IRQ #20

