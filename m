Return-Path: <linux-kernel-owner+w=401wt.eu-S1761101AbXLRRIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101AbXLRRIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbXLRRI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:08:28 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63121 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760860AbXLRRI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:08:27 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 0/5] atmel_serial: Cleanups, irq handler splitup & DMA
Date: Tue, 18 Dec 2007 18:06:10 +0100
Message-Id: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset cleans up the atmel_serial driver a bit,
moves a significant portion of the interrupt handler into a tasklet,
and adds DMA support. This is the result of a combined effort by Chip
Coldwell, Remy Bohmer and me. The patches should apply cleanly onto
Linus' latest git tree.

It all seems to behave both with and without DMA enabled, but I'll do
some more testing tomorrow.

Note that break and error handling doesn't work too well with DMA
enabled. This is a common problem with all the efforts I've seen
adding DMA support to this driver (including my own). I'm tempted to
just ignore the problem for now and hopefully come up with a solution
later.

Everyone, please give it a try and/or review the code.

PS: Andrew, I'm sending it to you because I believe you're the
maintainer of this driver, although MAINTAINERS doesn't say anything
about it. Please let me know if this isn't how you want it.

Chip Coldwell (1):
      atmel_serial: Add DMA support

Haavard Skinnemoen (2):
      atmel_serial: Use cpu_relax() when busy-waiting
      atmel_serial: Use existing console options only if BRG is running

Remy Bohmer (2):
      atmel_serial: Clean up the code
      atmel_serial: Split the interrupt handler

 drivers/serial/atmel_serial.c |  881 ++++++++++++++++++++++++++++++++---------
 1 files changed, 700 insertions(+), 181 deletions(-)
