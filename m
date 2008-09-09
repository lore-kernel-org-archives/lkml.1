Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYIIO1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYIIO1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYIIO05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:26:57 -0400
Received: from emita2.mittwald.de ([85.199.129.253]:56968 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYIIO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:26:57 -0400
X-Greylist: delayed 1283 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 10:26:56 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: OOPS: getting an ACPI interrupt while in an ACPI interrupt hangs my box
Date: Tue, 9 Sep 2008 16:05:07 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091605.07734.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got this OOPS:

irq 9: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Tainted: P          2.6.26.3 #3
 [<c012f063>] __report_bad_irq+0x24/0x69
 [<c012f06a>] __report_bad_irq+0x2b/0x69
 [<c012f257>] note_interrupt+0x1af/0x1e4
 [<c01cbc97>] acpi_irq+0xb/0x1c
 [<c012e983>] handle_IRQ_event+0x1a/0x3f
 [<c012f917>] handle_level_irq+0x63/0x84
 [<c01046d0>] do_IRQ+0x4b/0x60
 [<c010320f>] common_interrupt+0x23/0x28
 [<c01d007b>] acpi_ds_create_operands+0x1c/0xf9
 [<c0118f03>] __do_softirq+0x2c/0x75
 [<c0118f6e>] do_softirq+0x22/0x26
 [<c01191ea>] irq_exit+0x25/0x53
 [<c01046d5>] do_IRQ+0x50/0x60
 [<c010320f>] common_interrupt+0x23/0x28
 [<c01ef3c0>] acpi_idle_enter_simple+0x16d/0x1d9
 [<c025bdba>] cpuidle_idle_call+0x49/0x77
 [<c025bd71>] cpuidle_idle_call+0x0/0x77
 [<c010176c>] cpu_idle+0x48/0x61
 =======================
handlers:
[<c01cbc8c>] (acpi_irq+0x0/0x1c)
Disabling IRQ #9
BUG: soft lockup - CPU#0 stuck for 138s! [syslogd:1952]

If I read that OOPS right, then I got an interrupt 
("common_interrupt"), which made the kernel run the ACPI 
function "acpi_ds_create_operands" and while this executed, I've 
got another interupt, which killed my for for 138 seconds ...

Shouldn't there some sort of protection about this or is the DSDT 
of my device just bogus?




Kernel 2.6.26.3

CPU: "Geode(TM) Integrated Processor by AMD PCS"

How to reproduce: press ACPI buttons repeatedly

ACPI related kernel-commandline entries: "pci=noacpi 
acpi_serialize". The first is vital (no boot without), the 
second one is an experiment, I got OOPSes without that, too.
