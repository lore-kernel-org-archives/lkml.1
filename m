Return-Path: <linux-kernel-owner+w=401wt.eu-S1751588AbZGOCUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbZGOCUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZGOCUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:20:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42660 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZGOCUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:20:21 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Pau Oliva Fora <pof@eslack.org>, linux-input@vger.kernel.org
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jul 2009 07:50:08 +0530
Message-Id: <20090715022005.4244.67703.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 04/06] Fix compilation warning for drivers/input/touchscreen/htcpen.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.4.1 generates the following build warning on i386:

CC drivers/input/touchscreen/htcpen.o
drivers/input/touchscreen/htcpen.c:50: warning: ‘pnp_ids’ defined but not used

Fix this by removing the static keyword when you are actually
exporting that structure.

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
---

--- a/drivers/input/touchscreen/htcpen.c	2009-05-20 10:40:54.000000000 +0530
+++ b/drivers/input/touchscreen/htcpen.c	2009-07-15 06:15:34.000000000 +0530
@@ -47,7 +47,7 @@ static int invert_y;
 module_param(invert_y, bool, 0644);
 MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
 
-static struct pnp_device_id pnp_ids[] = {
+struct pnp_device_id pnp_ids[] = {
 	{ .id = "PNP0cc0" },
 	{ .id = "" }
 };

---
Regards--
Subrata

