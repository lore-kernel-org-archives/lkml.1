Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYBKPFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYBKPFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYBKPFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:05:41 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:38504 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYBKPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:05:40 -0500
Message-ID: <47B0643F.3090100@tiscali.nl>
Date: Mon, 11 Feb 2008 16:05:35 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ambx1@neo.rr.com, len.brown@intel.com
CC: linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/pnp/pnpacpi/core.c] __initdata is not an identifier
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains at drivers/pnp/pnpacpi/core.c:39 with the error:
Trying to use reserved word '__attribute__' as identifier
Expected ) in function declarator, got ".init.data"

and at drivers/pnp/pnpacpi/core.c:49:38 with the error: 
undefined identifier 'excluded_id_list'

With the patch below these sparse complaints do not occur
---
__initdata is not an identifier

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 662b4c2..c283a9a 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -36,7 +36,7 @@ static int num = 0;
  * have irqs (PIC, Timer) because we call acpi_register_gsi.
  * Finally, only devices that have a CRS method need to be in this list.
  */
-static struct __initdata acpi_device_id excluded_id_list[] = {
+static struct acpi_device_id excluded_id_list[] __initdata = {
 	{"PNP0C09", 0},		/* EC */
 	{"PNP0C0F", 0},		/* Link device */
 	{"PNP0000", 0},		/* PIC */
