Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXJMOl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXJMOl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXJMOls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:41:48 -0400
Received: from 1wt.eu ([62.212.114.60]:2872 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760753AbXJMOlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:41:47 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143423.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:23 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 01/35] ACPICA: Fixed possible corruption of global GPE list
Content-Disposition: inline; filename=0008-ACPICA-Fixed-possible-corruption-of-global-GPE-list.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPICA: Fixed possible corruption of global GPE list

Fixed a problem in acpi_ev_delete_gpe_xrupt where the global interrupt
list could be corrupted if the interrupt being removed was at
the head of the list. Reported by Linn Crosetto.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/events/evgpeblk.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

Index: 2.6/drivers/acpi/events/evgpeblk.c
===================================================================
--- 2.6.orig/drivers/acpi/events/evgpeblk.c
+++ 2.6/drivers/acpi/events/evgpeblk.c
@@ -586,6 +586,10 @@ acpi_ev_delete_gpe_xrupt(struct acpi_gpe
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next = gpe_xrupt->next;
+	} else {
+		/* No previous, update list head */
+
+		acpi_gbl_gpe_xrupt_list_head = gpe_xrupt->next;
 	}
 
 	if (gpe_xrupt->next) {

-- 
