Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZCCPSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZCCPSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZCCPSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:18:25 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:24764 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZCCPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:18:24 -0500
Date: Tue, 03 Mar 2009 09:18:11 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 1/5] IPMI: Fix platform return check
Message-id: <20090303151811.GA7777@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong return value is being tested when allocating a platform
device in the IPMI SI code.  Check the right value.

Signed-off-by: Corey Minyard <minyard@acm.org>
---
Index: linux-2.6.25/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.25.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.25/drivers/char/ipmi/ipmi_si_intf.c
@@ -2864,7 +2864,7 @@ static int try_smi_init(struct smi_info 
 		 */
 		new_smi->pdev = platform_device_alloc("ipmi_si",
 						      new_smi->intf_num);
-		if (rv) {
+		if (!new_smi->pdev) {
 			printk(KERN_ERR
 			       "ipmi_si_intf:"
 			       " Unable to allocate platform device\n");
