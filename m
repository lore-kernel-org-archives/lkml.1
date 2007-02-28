Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbXB1TYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbXB1TYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbXB1TYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:24:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbXB1TYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:24:02 -0500
Date: Wed, 28 Feb 2007 14:24:00 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mike.miller@hp.com, chirag.kantharia@hp.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070228192400.21367.2923.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Fix __init declarations in Compaq SMART2 Controller driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix __init declarations in Compaq SMART2 Controller driver.

Resolves MODPOST warnings similar to:

WARNING: drivers/block/cpqarray.o - Section mismatch: reference to
.init.text:cpqarray_init_one from .data.rel.local between 'cpqarray_pci_driver'
(at offset 0x20) and 'smart1_access'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux-2.6.18.ia64.orig/drivers/block/cpqarray.c	2007-02-14 11:36:20.000000000 -0500
+++ linux-2.6.18.ia64/drivers/block/cpqarray.c	2007-02-14 13:08:57.000000000 -0500
@@ -212,7 +212,7 @@ static struct proc_dir_entry *proc_array
  * Get us a file in /proc/array that says something about each controller.
  * Create /proc/array if it doesn't exist yet.
  */
-static void __init ida_procinit(int i)
+static void __devinit ida_procinit(int i)
 {
 	if (proc_array == NULL) {
 		proc_array = proc_mkdir("cpqarray", proc_root_driver);
@@ -390,7 +390,7 @@ static void __devexit cpqarray_remove_on
 }
 
 /* pdev is NULL for eisa */
-static int __init cpqarray_register_ctlr( int i, struct pci_dev *pdev)
+static int __devinit cpqarray_register_ctlr( int i, struct pci_dev *pdev)
 {
 	request_queue_t *q;
 	int j;
@@ -511,7 +511,7 @@ Enomem4:
 	return -1;
 }
 
-static int __init cpqarray_init_one( struct pci_dev *pdev,
+static int __devinit cpqarray_init_one( struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
 	int i;
