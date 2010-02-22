Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0BVTL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:11:57 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9837 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0BVTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:11:45 -0500
Subject: [PATCH v2 08/12] ACPI: processor: refactor internal map_lapic_id()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 22 Feb 2010 12:11:44 -0700
Message-ID: <20100222191144.19752.26827.stgit@bob.kio>
In-Reply-To: <20100222190145.19752.20978.stgit@bob.kio>
References: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untangle the if() statement a little for readability.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_core.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 626c754..9eeda9e 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -50,12 +50,15 @@ static int map_lapic_id(struct acpi_subtable_header *entry,
 {
 	struct acpi_madt_local_apic *lapic =
 		(struct acpi_madt_local_apic *)entry;
-	if ((lapic->lapic_flags & ACPI_MADT_ENABLED) &&
-	    lapic->processor_id == acpi_id) {
-		*apic_id = lapic->id;
-		return 1;
-	}
-	return 0;
+
+	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (lapic->processor_id != acpi_id)
+		return 0;
+
+	*apic_id = lapic->id;
+	return 1;
 }
 
 static int map_x2apic_id(struct acpi_subtable_header *entry,

