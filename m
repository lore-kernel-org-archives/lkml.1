Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbXKMVfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbXKMVfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760724AbXKMVfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:35:21 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59597 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760860AbXKMVfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:35:18 -0500
Date: Tue, 13 Nov 2007 22:35:14 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rolandd@cisco.com, mshefty@ichips.intel.com, halr@voltaire.com,
       openib-general@openib.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] drivers/infiniband: Drop redundant includes of moduleparam.h
Message-ID: <Pine.LNX.4.64.0711132234110.18337@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Drop #include <linux/moduleparam.h> in files that also include #include
<linux/module.h>.  module.h includes moduleparam.h already.

The semantic patch implementing this change is as follows:

@ includesmodule @
@@

#include <linux/module.h>

@ depends on includesmodule @
@@

- #include <linux/moduleparam.h>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
--- a/drivers/infiniband/hw/amso1100/c2.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/infiniband/hw/amso1100/c2.c 2007-11-13 17:50:03.000000000 +0100
@@ -31,7 +31,6 @@
   * SOFTWARE.
   */
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/pci.h>
  #include <linux/netdevice.h>
  #include <linux/etherdevice.h>
diff -u -p -b -B a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
--- a/drivers/infiniband/hw/amso1100/c2_provider.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c 2007-11-13 17:50:05.000000000 +0100
@@ -33,7 +33,6 @@
   */

  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/pci.h>
  #include <linux/netdevice.h>
  #include <linux/etherdevice.h>
diff -u -p -b -B a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c 2007-02-09 17:34:09.000000000 +0100
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c 2007-11-13 17:50:06.000000000 +0100
@@ -34,7 +34,6 @@


  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/pci.h>
  #include <linux/netdevice.h>
  #include <linux/etherdevice.h>
diff -u -p -b -B a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
--- a/drivers/infiniband/hw/ehca/ehca_tools.h 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h 2007-11-13 17:50:06.000000000 +0100
@@ -52,7 +52,6 @@
  #include <linux/mm.h>
  #include <linux/mman.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/vmalloc.h>
  #include <linux/version.h>
  #include <linux/notifier.h>
diff -u -p -b -B a/drivers/infiniband/hw/mthca/mthca_profile.c b/drivers/infiniband/hw/mthca/mthca_profile.c
--- a/drivers/infiniband/hw/mthca/mthca_profile.c 2007-06-02 22:32:12.000000000 +0200
+++ b/drivers/infiniband/hw/mthca/mthca_profile.c 2007-11-13 17:50:23.000000000 +0100
@@ -34,7 +34,6 @@
   */

  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/string.h>
  #include <linux/slab.h>

diff -u -p -b -B a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
--- a/drivers/infiniband/hw/cxgb3/iwch.c 2007-06-02 22:32:12.000000000 +0200
+++ b/drivers/infiniband/hw/cxgb3/iwch.c 2007-11-13 17:50:25.000000000 +0100
@@ -30,7 +30,6 @@
   * SOFTWARE.
   */
  #include <linux/module.h>
-#include <linux/moduleparam.h>

  #include <rdma/ib_verbs.h>

diff -u -p -b -B a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c 2007-07-20 17:45:46.000000000 +0200
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c 2007-11-13 17:50:27.000000000 +0100
@@ -30,7 +30,6 @@
   * SOFTWARE.
   */
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/device.h>
  #include <linux/netdevice.h>
  #include <linux/etherdevice.h>
