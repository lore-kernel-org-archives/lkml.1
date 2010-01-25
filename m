Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848Ab0AYVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0AYVlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661Ab0AYVlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:41:42 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9083 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0AYVlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:41:40 -0500
Subject: [PATCH 12/12] ACPI: processor core: style and sparse cleanups
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Jan 2010 14:41:39 -0700
Message-ID: <20100125214139.28510.60920.stgit@bob.kio>
In-Reply-To: <20100125213221.28510.74078.stgit@bob.kio>
References: <20100125213221.28510.74078.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless comments
Remove useless braces
Cleanup local variable declarations
Remove shadow declarations

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_core.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ae69f6d..4c34ec0 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -46,9 +46,9 @@ static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
 static int map_lapic_id(struct acpi_subtable_header *entry,
 		 u32 acpi_id, int *apic_id)
 {
-	struct acpi_madt_local_apic *lapic =
-		(struct acpi_madt_local_apic *)entry;
+	struct acpi_madt_local_apic *lapic;
 
+	lapic = (struct acpi_madt_local_apic *)entry;
 	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
 		return 0;
 
@@ -62,14 +62,14 @@ static int map_lapic_id(struct acpi_subtable_header *entry,
 static int map_x2apic_id(struct acpi_subtable_header *entry,
 			 int device_declaration, u32 acpi_id, int *apic_id)
 {
-	struct acpi_madt_local_x2apic *apic =
-		(struct acpi_madt_local_x2apic *)entry;
+	struct acpi_madt_local_x2apic *lx2apic;
 
-	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
+	lx2apic = (struct acpi_madt_local_x2apic *)entry;
+	if (!(lx2apic->lapic_flags & ACPI_MADT_ENABLED))
 		return 0;
 
-	if (device_declaration && (apic->uid == acpi_id)) {
-		*apic_id = apic->local_apic_id;
+	if (device_declaration && (lx2apic->uid == acpi_id)) {
+		*apic_id = lx2apic->local_apic_id;
 		return 1;
 	}
 
@@ -79,9 +79,9 @@ static int map_x2apic_id(struct acpi_subtable_header *entry,
 static int map_lsapic_id(struct acpi_subtable_header *entry,
 		int device_declaration, u32 acpi_id, int *apic_id)
 {
-	struct acpi_madt_local_sapic *lsapic =
-		(struct acpi_madt_local_sapic *)entry;
+	struct acpi_madt_local_sapic *lsapic;
 
+	lsapic = (struct acpi_madt_local_sapic *)entry;
 	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
 		return 0;
 
@@ -98,6 +98,7 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
+	struct acpi_subtable_header *header;
 	static struct acpi_table_madt *madt;
 	static int read_madt;
 	int apic_id = -1;
@@ -115,12 +116,10 @@ static int map_madt_entry(int type, u32 acpi_id)
 	entry = (unsigned long)madt;
 	madt_end = entry + madt->header.length;
 
-	/* Parse all entries looking for a match. */
-
 	entry += sizeof(struct acpi_table_madt);
 	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
-		struct acpi_subtable_header *header =
-			(struct acpi_subtable_header *)entry;
+		header = (struct acpi_subtable_header *)entry;
+
 		if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
 			if (map_lapic_id(header, acpi_id, &apic_id))
 				break;
@@ -151,20 +150,17 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 
 	obj = buffer.pointer;
 	if (obj->type != ACPI_TYPE_BUFFER ||
-	    obj->buffer.length < sizeof(struct acpi_subtable_header)) {
+	    obj->buffer.length < sizeof(struct acpi_subtable_header))
 		goto exit;
-	}
 
 	header = (struct acpi_subtable_header *)obj->buffer.pointer;
-	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC)
 		map_lapic_id(header, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC)
 		map_lsapic_id(header, type, acpi_id, &apic_id);
-	}
 
 exit:
-	if (buffer.pointer)
-		kfree(buffer.pointer);
+	kfree(buffer.pointer);
 	return apic_id;
 }
 
@@ -179,10 +175,9 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 	if (apic_id == -1)
 		return apic_id;
 
-	for_each_possible_cpu(i) {
+	for_each_possible_cpu(i)
 		if (cpu_physical_id(i) == apic_id)
 			return i;
-	}
 	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);

