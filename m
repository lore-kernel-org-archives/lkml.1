Return-Path: <linux-kernel-owner+w=401wt.eu-S1767565AbXDFKUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767565AbXDFKUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767560AbXDFKUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:20:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44152 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767559AbXDFKTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:19:48 -0400
Date: Fri, 6 Apr 2007 12:19:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Richard Knutsson <ricknu-0@student.ltu.se>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [-mm patch] the overdue removal of pci_module_init()
Message-ID: <20070406101948.GE29169@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unless we finally completely remove it, people will always add new users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch obsoletes mark-pci_module_init-deprecated.patch in -mm.

 Documentation/feature-removal-schedule.txt |    7 -------
 Documentation/pci.txt                      |    2 --
 include/linux/pci.h                        |    6 ------
 3 files changed, 15 deletions(-)

--- linux-2.6.21-rc5-mm4/Documentation/feature-removal-schedule.txt.old	2007-04-05 20:47:53.000000000 +0200
+++ linux-2.6.21-rc5-mm4/Documentation/feature-removal-schedule.txt	2007-04-05 20:48:03.000000000 +0200
@@ -104,13 +104,6 @@
 
 ---------------------------
 
-What:	pci_module_init(driver)
-When:	January 2007
-Why:	Is replaced by pci_register_driver(pci_driver).
-Who:	Richard Knutsson <ricknu-0@student.ltu.se> and Greg Kroah-Hartman <gregkh@suse.de>
-
----------------------------
-
 What:	Usage of invalid timevals in setitimer
 When:	March 2007
 Why:	POSIX requires to validate timevals in the setitimer call. This
--- linux-2.6.21-rc5-mm4/Documentation/pci.txt.old	2007-04-05 20:48:16.000000000 +0200
+++ linux-2.6.21-rc5-mm4/Documentation/pci.txt	2007-04-05 20:48:25.000000000 +0200
@@ -545,8 +545,6 @@
 pci_set_power_state()		Set PCI Power Management state (0=D0 ... 3=D3)
 pci_find_capability()		Find specified capability in device's capability
 				list.
-pci_module_init()		Inline helper function for ensuring correct
-				pci_driver initialization and error handling.
 pci_resource_start()		Returns bus start address for a given PCI region
 pci_resource_end()		Returns bus end address for a given PCI region
 pci_resource_len()		Returns the byte length of a PCI region
--- linux-2.6.21-rc5-mm4/include/linux/pci.h.old	2007-04-05 20:48:37.000000000 +0200
+++ linux-2.6.21-rc5-mm4/include/linux/pci.h	2007-04-05 20:48:43.000000000 +0200
@@ -410,12 +410,6 @@
 	.vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
-/*
- * pci_module_init is obsolete, this stays here till we fix up all usages of it
- * in the tree.
- */
-#define pci_module_init	pci_register_driver
-
 /**
  * PCI_VDEVICE - macro used to describe a specific pci device in short form
  * @vend: the vendor name

