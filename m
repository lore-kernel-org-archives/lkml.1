Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbYFSHhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbYFSHhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 03:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYFSHhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 03:37:02 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:13197 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323AbYFSHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 03:37:00 -0400
Date: Thu, 19 Jun 2008 16:36:48 +0900 (JST)
Message-Id: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH] jedec_probe: Fix SST 16-bit chip detection
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unlock_addr rework in kernel 2.6.25 breaks 16-bit SST chips.  SST
39LF160 and SST 39VF1601 are both 16-bit only chip and new uaddr value
is not correct for them.  Add MTD_UADDR_0xAAAA_0x5555 for those chips.
Tested with SST 39VF1601 chip.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/mtd/chips/jedec_probe.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index aa07575..97395be 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -191,6 +191,7 @@ enum uaddr {
 	MTD_UADDR_0x0555_0x0AAA,
 	MTD_UADDR_0x5555_0x2AAA,
 	MTD_UADDR_0x0AAA_0x0555,
+	MTD_UADDR_0xAAAA_0x5555,
 	MTD_UADDR_DONT_CARE,		/* Requires an arbitrary address */
 	MTD_UADDR_UNNECESSARY,		/* Does not require any address */
 };
@@ -238,6 +239,11 @@ static const struct unlock_addr  unlock_addrs[] = {
 		.addr2 = 0x0555
 	},
 
+	[MTD_UADDR_0xAAAA_0x5555] = {
+		.addr1 = 0xaaaa,
+		.addr2 = 0x5555
+	},
+
 	[MTD_UADDR_DONT_CARE] = {
 		.addr1 = 0x0000,      /* Doesn't matter which address */
 		.addr2 = 0x0000       /* is used - must be last entry */
@@ -1392,8 +1398,8 @@ static const struct amd_flash_info jedec_table[] = {
 		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
 		.dev_id		= SST39LF160,
 		.name		= "SST 39LF160",
-		.devtypes	= CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
-		.uaddr		= MTD_UADDR_0x5555_0x2AAA,	/* ???? */
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
 		.dev_size	= SIZE_2MiB,
 		.cmd_set	= P_ID_AMD_STD,
 		.nr_regions	= 2,
@@ -1405,8 +1411,8 @@ static const struct amd_flash_info jedec_table[] = {
 		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
 		.dev_id		= SST39VF1601,
 		.name		= "SST 39VF1601",
-		.devtypes	= CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
-		.uaddr		= MTD_UADDR_0x5555_0x2AAA,	/* ???? */
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
 		.dev_size	= SIZE_2MiB,
 		.cmd_set	= P_ID_AMD_STD,
 		.nr_regions	= 2,
