Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZLBRcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZLBRcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZLBRcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:32:51 -0500
Received: from asgaard.lystrup.terma.com ([193.163.1.112]:55856 "EHLO
	asgaard.terma.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755013AbZLBRcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:32:50 -0500
X-Greylist: delayed 2186 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 12:32:50 EST
Subject: Adding a a new interrupt controller over PCIe.
From: Esben Nielsen <esn@terma.com>
Reply-To: esn@terma.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Terma Elektronik A/S
Date: Wed, 02 Dec 2009 17:56:25 +0100
Message-Id: <1259772985.2406.133.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
X-OriginalArrivalTime: 02 Dec 2009 16:56:26.0022 (UTC) FILETIME=[6289F460:01CA7370]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

We have an application where we have Xilinx FPGAs attached to our main
CPU (x86) via PCI-express. In the FPGAs we have among other things
relatively standeard UARTs and ethernet devices and we want to use
standeard drivers. But all the interrupts from these devices are
channelled into one interrupt controller
(http://www.xilinx.com/support/documentation/ip_documentation/xps_intc.pdf) per FPGA giving us one MSI interrupt to the CPU per FPGA.

The FPGAs are "hotplugged".

I can see some examples in the tree of people adding interrupt
controllers using struct irq_chip - but all at startup and on non-x86
architectures.

I tried to use the irq_chip structure and calls to create_irq_nr(),
set_irq_chip() and friends to get chained irq numbers belonging to the
new interrupt controller. But create_irq_nr() fails for me, and when I
look into the x86 implementation of it
( arch/x86/kernel/apic/io_apic.c), I see that it only supports
traditional APIC interrupts: It assumes that all irq_desc->chip_data are
a irq_cfg, not a general thing.

Have anyone dealt with anything similar?
Am I on the completely wrong track?

Esben
