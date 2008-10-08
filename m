Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYJHHa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYJHHa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYJHHar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:30:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45181 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYJHHaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:30:46 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Date: Wed, 8 Oct 2008 12:56:33 +0530
Subject: [PATCH 5/5] HDQ: Documentation for OMAP HDQ
Thread-Topic: [PATCH 5/5] HDQ: Documentation for OMAP HDQ
Thread-Index: AckpFzD8L/bz9btRRCmGA+EZO/Pp+A==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF7@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

This patch adds a brief documentation about omap2430/3430 HDQ/1-wire driver.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
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