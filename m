Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZGUCXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZGUCXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZGUCXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:23:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55046 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZGUCXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:23:51 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Pau Oliva Fora <pof@eslack.org>, linux-input@vger.kernel.org
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jul 2009 07:53:44 +0530
Message-Id: <20090721022344.30853.25784.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 04/06][RESEND] Fix compilation warning for drivers/input/touchscreen/htcpen.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.4.1 generates the following build warning on i386:

CC drivers/input/touchscreen/htcpen.o
drivers/input/touchscreen/htcpen.c:50: warning: 'pnp_ids' defined but not used

Fix this by removing the static keyword when you are actually exporting
that structure. This patch was earlier posted on 14th July 2009:
http://lkml.org/lkml/2009/7/14/362,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>
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

