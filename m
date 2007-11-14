Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbXKNCJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbXKNCJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbXKNCFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:34 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4781 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761343AbXKNCFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:32 -0500
Subject: [PATCH] - [12/15] - remove defconfig ptr comparisons to 0 -
	include/asm-x86
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:32 -0800
Message-Id: <1195005932.5163.98.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

The memcpy from memory location 0 sure looks odd.

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/include/asm-x86/mach-es7000/mach_mpparse.h b/include/asm-x86/mach-es7000/mach_mpparse.h
index 8aa1054..a1dd66f 100644
--- a/include/asm-x86/mach-es7000/mach_mpparse.h
+++ b/include/asm-x86/mach-es7000/mach_mpparse.h
@@ -29,7 +29,7 @@ extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
 static inline int es7000_check_dsdt(void)
 {
 	struct acpi_table_header header;
-	memcpy(&header, 0, sizeof(struct acpi_table_header));
+	memcpy(&header, (void *)0, sizeof(struct acpi_table_header));
 	acpi_get_table_header(ACPI_SIG_DSDT, 0, &header);
 	if (!strncmp(header.oem_id, "UNISYS", 6))
 		return 1;


