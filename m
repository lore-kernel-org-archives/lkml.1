Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYCUEOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYCUEOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYCUEOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:14:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44900 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYCUEOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:14:09 -0400
Message-ID: <47E3356D.6010509@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:11:25 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH  3/16][BUG] ACPI pci_slot: Fix _STA evaluation (Not for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the problem that pci slots that doesn't have _STA are not
detected. If the device doesn't have _STA, we must assume it is always
there.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
---
 drivers/acpi/pci_slot.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.25-rc6/drivers/acpi/pci_slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/acpi/pci_slot.c
+++ linux-2.6.25-rc6/drivers/acpi/pci_slot.c
@@ -76,9 +76,8 @@ check_slot(acpi_handle handle, int *devi
 
 	if (check_sta_before_sun) {
 		/* If SxFy doesn't have _STA, we just assume it's there */
-		acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-
-		if (!(sta & ACPI_STA_DEVICE_PRESENT)) {
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+		if (ACPI_SUCCESS(status) && !(sta & ACPI_STA_DEVICE_PRESENT)) {
 			retval = -1;
 			goto out;
 		}


