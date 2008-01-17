Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYAQH2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYAQH2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYAQH2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:28:13 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:64753 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYAQH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:28:12 -0500
Message-ID: <478F02FF.7040402@freemail.hu>
Date: Thu, 17 Jan 2008 08:25:51 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: EC: add leading zeros to debug messages
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Add leading zeros to pr_debug() calls. For example if x=0x0a, the format
"0x%2x" will result the string "0x a", the format "0x%2.2x" will result "0x0a".

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.24-rc8/drivers/acpi/ec.c.orig	2008-01-16 07:25:33.000000000 +0100
+++ linux-2.6.24-rc8/drivers/acpi/ec.c	2008-01-17 07:15:10.000000000 +0100
@@ -138,26 +138,26 @@ static struct acpi_ec {
 static inline u8 acpi_ec_read_status(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->command_addr);
-	pr_debug(PREFIX "---> status = 0x%2x\n", x);
+	pr_debug(PREFIX "---> status = 0x%2.2x\n", x);
 	return x;
 }

 static inline u8 acpi_ec_read_data(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->data_addr);
-	pr_debug(PREFIX "---> data = 0x%2x\n", x);
+	pr_debug(PREFIX "---> data = 0x%2.2x\n", x);
 	return inb(ec->data_addr);
 }

 static inline void acpi_ec_write_cmd(struct acpi_ec *ec, u8 command)
 {
-	pr_debug(PREFIX "<--- command = 0x%2x\n", command);
+	pr_debug(PREFIX "<--- command = 0x%2.2x\n", command);
 	outb(command, ec->command_addr);
 }

 static inline void acpi_ec_write_data(struct acpi_ec *ec, u8 data)
 {
-	pr_debug(PREFIX "<--- data = 0x%2x\n", data);
+	pr_debug(PREFIX "<--- data = 0x%2.2x\n", data);
 	outb(data, ec->data_addr);
 }

