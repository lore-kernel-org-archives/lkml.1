Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbXJVELU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbXJVELU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXJVELI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:11:08 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:38784 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbXJVELH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:11:07 -0400
Date: Sun, 21 Oct 2007 23:10:57 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH] IPMI: fix comparison in demangle_device_id
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>, Stian Jordet <liste@jordet.net>
Reply-to: minyard@acm.org
Message-id: <20071022041057.GA11676@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Coverity spotted some incorrect code in a recent change to the IPMI
driver; this patch make sure the data is really long enough to pull
the manufacturer id and product id out of a get device id message.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Stian Jordet <liste@jordet.net>
---
Index: linux-2.6.23/include/linux/ipmi_smi.h
===================================================================
--- linux-2.6.23.orig/include/linux/ipmi_smi.h
+++ linux-2.6.23/include/linux/ipmi_smi.h
@@ -173,7 +173,7 @@ static inline int ipmi_demangle_device_i
 	id->firmware_revision_2 = data[3];
 	id->ipmi_version = data[4];
 	id->additional_device_support = data[5];
-	if (data_len >= 6) {
+	if (data_len >= 11) {
 		id->manufacturer_id = (data[6] | (data[7] << 8) |
 				       (data[8] << 16));
 		id->product_id = data[9] | (data[10] << 8);
