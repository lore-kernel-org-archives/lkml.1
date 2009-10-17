Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbZJQGei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbZJQGei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZJQGei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:34:38 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51658 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZJQGeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:34:37 -0400
Date: Sat, 17 Oct 2009 08:34:39 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/14] drivers/acpi: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170834200.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on pr is needed, then the dereference should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/acpi/processor_throttling.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 4c6c14c..1c5d7a8 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -1133,15 +1133,15 @@ int acpi_processor_get_throttling_info(struct acpi_processor *pr)
 	int result = 0;
 	struct acpi_processor_throttling *pthrottling;
 
+	if (!pr)
+		return -EINVAL;
+
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "pblk_address[0x%08x] duty_offset[%d] duty_width[%d]\n",
 			  pr->throttling.address,
 			  pr->throttling.duty_offset,
 			  pr->throttling.duty_width));
 
-	if (!pr)
-		return -EINVAL;
-
 	/*
 	 * Evaluate _PTC, _TSS and _TPC
 	 * They must all be present or none of them can be used.
