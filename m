Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0BVSLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:11:04 -0500
Received: from smtp.nokia.com ([192.100.122.230]:18830 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab0BVSK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:10:56 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH 11/11] drivers: acpi: don't use own implementation of hex_to_bin()
Date: Mon, 22 Feb 2010 20:09:10 +0200
Message-Id: <6c9ddf543ee5880fa8560e7ab90aeb3e934499e3.1266861292.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <727e1d8eb3bd9a859f1e28a50b60becb7ca3acbe.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8efe17f827514a0c470191dccaf00afd09c2854.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <8470deda388af7015db44e96fa69560dd6e30126.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5c02662a55439f65791e24b8282d4face566955e.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <1c143f904aaf005e81f1adf057d8c8df8b6ea294.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <1592c1379a6fda43140d113bb8001badce461bd9.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <727e1d8eb3bd9a859f1e28a50b60becb7ca3acbe.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:34.0604 (UTC) FILETIME=[53F932C0:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
introduced by starter patch in the series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/bus.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index a52126e..c42a692 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -362,11 +362,6 @@ static void acpi_print_osc_error(acpi_handle handle,
 	printk("\n");
 }
 
-static u8 hex_val(unsigned char c)
-{
-	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
-}
-
 static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 {
 	int i;
@@ -383,8 +378,8 @@ static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 			return AE_BAD_PARAMETER;
 	}
 	for (i = 0; i < 16; i++) {
-		uuid[i] = hex_val(str[opc_map_to_uuid[i]]) << 4;
-		uuid[i] |= hex_val(str[opc_map_to_uuid[i] + 1]);
+		uuid[i] = hex_to_bin(str[opc_map_to_uuid[i]]) << 4;
+		uuid[i] |= hex_to_bin(str[opc_map_to_uuid[i] + 1]);
 	}
 	return AE_OK;
 }
-- 
1.5.6.5

