Return-Path: <linux-kernel-owner+w=401wt.eu-S1763137AbYGBHXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763137AbYGBHXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761246AbYGBHWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:22:39 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:44867 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760540AbYGBHWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:22:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j6VcDerD45HzT7JosExB9k3o1FVryMt+XAkHtGN5ZtfAs+PxpKV78cYVPTRld+8rDuMckcizl8rcOM3QjaIZGzx/XbezajBnVqKyZpqyToPOlZ4h+GIDzUhtMvSFgroDs7JOwxrwuDlonIKbMOju3Xnz/GHP0kfQOcVXskMEYow=  ;
X-YMail-OSG: dG1zvaEVM1leFp.3m6s0nZ._d1wisoHeoITnV0gslQLX_d..ZHFEDgtKkuVn1AfLz0Qg4qgYWNYl.UNaMu4ktn0Ti.Y4_dD7FcXipAbl_Jbnqw_ONKvxSA93go.oR2x0CG0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc8] mfd: fix platform driver hotplug/coldplug
Date: Wed, 2 Jul 2008 00:18:47 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       philipp.zabel@gmail.com, Russell King <rmk@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020018.47634.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to
the MFD platform drivers, to re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
[ dbrownell@users.sourceforge.net: one was missing ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/htc-pasic3.c |    2 ++
 drivers/mfd/mcp-sa11x0.c |    2 ++
 drivers/mfd/sm501.c      |    2 ++
 3 files changed, 6 insertions(+)

--- a/drivers/mfd/htc-pasic3.c	2008-07-02 00:15:20.000000000 -0700
+++ b/drivers/mfd/htc-pasic3.c	2008-07-02 00:15:31.000000000 -0700
@@ -238,6 +238,8 @@ static int pasic3_remove(struct platform
 	return 0;
 }
 
+MODULE_ALIAS("platform:pasic3");
+
 static struct platform_driver pasic3_driver = {
 	.driver		= {
 		.name	= "pasic3",
--- a/drivers/mfd/mcp-sa11x0.c	2008-07-02 00:10:11.000000000 -0700
+++ b/drivers/mfd/mcp-sa11x0.c	2008-07-02 00:13:41.000000000 -0700
@@ -242,6 +242,8 @@ static int mcp_sa11x0_resume(struct plat
 /*
  * The driver for the SA11x0 MCP port.
  */
+MODULE_ALIAS("platform:sa11x0-mcp");
+
 static struct platform_driver mcp_sa11x0_driver = {
 	.probe		= mcp_sa11x0_probe,
 	.remove		= mcp_sa11x0_remove,
--- a/drivers/mfd/sm501.c	2008-07-02 00:10:11.000000000 -0700
+++ b/drivers/mfd/sm501.c	2008-07-02 00:13:41.000000000 -0700
@@ -1378,6 +1378,8 @@ static struct pci_driver sm501_pci_drv =
 	.remove		= sm501_pci_remove,
 };
 
+MODULE_ALIAS("platform:sm501");
+
 static struct platform_driver sm501_plat_drv = {
 	.driver		= {
 		.name	= "sm501",
