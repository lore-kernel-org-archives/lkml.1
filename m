Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZESDXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZESDXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 23:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZESDXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 23:23:24 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:43490 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZESDXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 23:23:23 -0400
Subject: [PATCH] ACPICA: Eliminate double call to acpi_ns_get_parent_node in
	acpi_get_parent
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Robert Moore <robert.moore@intel.com>
Date: Mon, 18 May 2009 21:23:24 -0600
Message-ID: <20090519032244.3729.46729.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the value of the parent node so we don't have to look it up twice.

Cc: Robert Moore <robert.moore@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/acpica/nsxfobj.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/nsxfobj.c b/drivers/acpi/acpica/nsxfobj.c
index 1c7efc1..1cd8f15 100644
--- a/drivers/acpi/acpica/nsxfobj.c
+++ b/drivers/acpi/acpica/nsxfobj.c
@@ -161,7 +161,7 @@ ACPI_EXPORT_SYMBOL(acpi_get_type)
  ******************************************************************************/
 acpi_status acpi_get_parent(acpi_handle handle, acpi_handle * ret_handle)
 {
-	struct acpi_namespace_node *node;
+	struct acpi_namespace_node *node, *parent_node;
 	acpi_status status;
 
 	if (!ret_handle) {
@@ -189,12 +189,12 @@ acpi_status acpi_get_parent(acpi_handle handle, acpi_handle * ret_handle)
 
 	/* Get the parent entry */
 
-	*ret_handle =
-	    acpi_ns_convert_entry_to_handle(acpi_ns_get_parent_node(node));
+	parent_node = acpi_ns_get_parent_node(node);
+	*ret_handle = acpi_ns_convert_entry_to_handle(parent_node);
 
 	/* Return exception if parent is null */
 
-	if (!acpi_ns_get_parent_node(node)) {
+	if (!parent_node) {
 		status = AE_NULL_ENTRY;
 	}
 

