Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765Ab0AYVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0AYVlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605Ab0AYVle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:41:34 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:47569 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0AYVla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:41:30 -0500
Subject: [PATCH 09/12] ACPI: processor: refactor internal map_x2apic_id()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Jan 2010 14:41:24 -0700
Message-ID: <20100125214124.28510.81186.stgit@bob.kio>
In-Reply-To: <20100125213221.28510.74078.stgit@bob.kio>
References: <20100125213221.28510.74078.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untangle the nested if conditions to make this function look
more similar to the other map_*apic_id() functions.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_core.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index bebd411..9213f95 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -66,22 +66,16 @@ static int map_x2apic_id(struct acpi_subtable_header *entry,
 {
 	struct acpi_madt_local_x2apic *apic =
 		(struct acpi_madt_local_x2apic *)entry;
-	u32 tmp = apic->local_apic_id;
 
-	/* Only check enabled APICs*/
 	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
 		return 0;
 
-	/* Device statement declaration type */
-	if (device_declaration) {
-		if (apic->uid == acpi_id)
-			goto found;
+	if (device_declaration && (apic->uid == acpi_id)) {
+		*apic_id = apic->local_apic_id;
+		return 1;
 	}
 
 	return 0;
-found:
-	*apic_id = tmp;
-	return 1;
 }
 
 static int map_lsapic_id(struct acpi_subtable_header *entry,

