Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZA3Wpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZA3Wpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbZA3Wo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:44:56 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:2268 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbZA3Woy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:44:54 -0500
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH 1/2] ACPICA: Fix table entry truncation calculation
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       myron.stowe@hp.com, Myron Stowe <myron.stowe@hp.com>
Date: Fri, 30 Jan 2009 15:44:53 -0700
Message-ID: <20090130224453.24329.32589.stgit@bob.kio>
In-Reply-To: <20090130223832.24329.5434.stgit@bob.kio>
References: <20090130223832.24329.5434.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot, ACPI RSDT/XSDT table entries are gathered into the
'initial_tables[]' array.  This array is currently statically defined (see
./drivers/acpi/tables.c).  When there are more table entries than can be
held in the 'initial_tables[]' array, the message "Truncating N table
entries!" is output.  As currently implemented, this message will always
erroneously calculate N as 0.

This patch fixes the calculation that determines how many table entries
will be missing (truncated).


This modification may be used under either the GPL or the BSD-style
license used for Intel ACPI CA code.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
---

 drivers/acpi/acpica/tbutils.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 9684cc8..22ce489 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -538,10 +538,9 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address, u8 flags)
 			if (ACPI_FAILURE(status)) {
 				ACPI_WARNING((AE_INFO,
 					      "Truncating %u table entries!",
-					      (unsigned)
-					      (acpi_gbl_root_table_list.size -
-					       acpi_gbl_root_table_list.
-					       count)));
+					      (unsigned) (table_count -
+					       (acpi_gbl_root_table_list.
+					       count - 2))));
 				break;
 			}
 		}

