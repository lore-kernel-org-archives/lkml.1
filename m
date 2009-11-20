Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZKTNpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZKTNpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZKTNpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:45:53 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:28646 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZKTNpw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;2:1>);
	Fri, 20 Nov 2009 08:45:52 -0500
Message-Id: <4B06ABA802000078000211D2@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 20 Nov 2009 13:46:00 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <Douglas_Warzecha@Dell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] use proper address translation functions in DCDBAS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one case, the properly translated address is already available, in
the other virt_to_bus() ought to be used (in particular for Xen
compatibility).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/firmware/dcdbas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.32-rc8/drivers/firmware/dcdbas.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.32-rc8-dcdbas/drivers/firmware/dcdbas.c	2009-10-26 16:34:02.000000000 +0100
@@ -106,7 +106,7 @@ static int smi_data_buf_realloc(unsigned
 	/* set up new buffer for use */
 	smi_data_buf = buf;
 	smi_data_buf_handle = handle;
-	smi_data_buf_phys_addr = (u32) virt_to_phys(buf);
+	smi_data_buf_phys_addr = (u32) handle;
 	smi_data_buf_size = size;
 
 	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
@@ -319,7 +319,7 @@ static ssize_t smi_request_store(struct 
 		break;
 	case 1:
 		/* Calling Interface SMI */
-		smi_cmd->ebx = (u32) virt_to_phys(smi_cmd->command_buffer);
+		smi_cmd->ebx = (u32) virt_to_bus(smi_cmd->command_buffer);
 		ret = dcdbas_smi_request(smi_cmd);
 		if (!ret)
 			ret = count;



