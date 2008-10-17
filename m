Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYJQOz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYJQOz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYJQOzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:55:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36280 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbYJQOzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:55:45 -0400
From: Madhu Chikkature <madhu.cr@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: [Resending PATCH 4/4] HDQ: Documentation for OMAP HDQ
Date: Fri, 17 Oct 2008 20:25:17 +0530
Message-Id: <1224255317-22165-1-git-send-email-madhu.cr@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

This patch adds a brief documentation about omap2430/3430 HDQ/1-wire driver.

Signed-off-by: Madhusudhan Chikkature<madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 Documentation/w1/masters/omap-hdq |   46 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+)

Index: linux-omap-2.6/Documentation/w1/masters/omap-hdq
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/Documentation/w1/masters/omap-hdq	2007-12-17 15:43:26.306248879 +0530
@@ -0,0 +1,46 @@
+Kernel driver for omap HDQ/1-wire module.
+========================================
+
+Supported chips:
+================
+	HDQ/1-wire controller on the TI OMAP 2430/3430 platforms.
+
+A useful link about HDQ basics:
+===============================
+http://focus.ti.com/lit/an/slua408/slua408.pdf
+
+Description:
+============
+The HDQ/1-Wire module of TI OMAP2430/3430 platforms implement the hardware
+protocol of the master functions of the Benchmark HDQ and the Dallas
+Semiconductor 1-Wire protocols. These protocols use a single wire for
+communication between the master (HDQ/1-Wire controller) and the slave
+(HDQ/1-Wire external compliant device).
+
+A typical application of the HDQ/1-Wire module is the communication with battery
+monitor (gas gauge) integrated circuits.
+
+The controller supports operation in both HDQ and 1-wire mode. The essential
+difference between the HDQ and 1-wire mode is how the slave device responds to
+initialization pulse.In HDQ mode, the firmware does not require the host to
+create an initialization pulse to the slave.However, the slave can be reset by
+using an initialization pulse (also referred to as a break pulse).The slave
+does not respond with a presence pulse as it does in the 1-Wire protocol.
+
+Remarks:
+========
+The driver (drivers/w1/masters/omap_hdq.c) supports the HDQ mode of the
+controller. In this mode, as we can not read the ID which obeys the W1
+spec(family:id:crc), a module parameter can be passed to the driver which will
+be used to calculate the CRC and pass back an appropriate slave ID to the W1
+core.
+
+By default the master driver and the BQ slave i/f
+driver(drivers/w1/slaves/w1_bq27000.c) sets the ID to 1.
+Please note to load both the modules with a different ID if required, but note
+that the ID used should be same for both master and slave driver loading.
+
+e.g:
+insmod omap_hdq.ko W1_ID=2
+inamod w1_bq27000.ko F_ID=2
+
