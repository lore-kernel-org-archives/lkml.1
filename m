Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789Ab0AVVtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0AVVtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763Ab0AVVtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:49:13 -0500
Received: from server78.greatnet.de ([83.133.96.102]:48992 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab0AVVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:49:10 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: jonathan@buzzard.org.uk
Cc: alan@linux.intel.com, tlinux-users@tce.toshiba-dme.co.jp,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 2/4] [DRIVERS]: use __init in drivers/char/toshiba.c
Date: Fri, 22 Jan 2010 22:41:10 +0100
Message-Id: <1264196472-5387-2-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1264196472-5387-1-git-send-email-henne@nachtwindheim.de>
References: <1264196472-5387-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __init on functions which are only called while loading the driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/char/toshiba.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 4644ea8..8e686ac 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -344,7 +344,7 @@ static const struct file_operations proc_toshiba_fops = {
 /*
  * Determine which port to use for the Fn key status
  */
-static void tosh_set_fn_port(void)
+static void __init tosh_set_fn_port(void)
 {
 	switch (tosh_id) {
 		case 0xfc02: case 0xfc04: case 0xfc09: case 0xfc0a: case 0xfc10:
@@ -368,7 +368,7 @@ static void tosh_set_fn_port(void)
 /*
  * Get the machine identification number of the current model
  */
-static int tosh_get_machine_id(void __iomem *bios)
+static int __init tosh_get_machine_id(void __iomem *bios)
 {
 	int id;
 	SMMRegisters regs;
@@ -424,7 +424,7 @@ static int tosh_get_machine_id(void __iomem *bios)
  *   laptop, otherwise zero and determines the Machine ID, BIOS version and
  *   date, and SCI version.
  */
-static int tosh_probe(void)
+static int __init tosh_probe(void)
 {
 	int i,major,minor,day,year,month,flag;
 	unsigned char signature[7] = { 0x54,0x4f,0x53,0x48,0x49,0x42,0x41 };
-- 
1.6.5

