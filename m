Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbZDISqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbZDISqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764356AbZDISpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:45:50 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:22425 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756889AbZDISpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:45:50 -0400
Date: Thu, 09 Apr 2009 12:45:48 -0600
From: dougthompson@xmission.com
To: khali@linux-fr.org, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: new fix worktodo to proper cast
Message-ID: <49de425c.Crgzs57fqLG2PZss%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

The edac-core driver includes code which assumes that the work_struct
which is included in every delayed_work is the first member of that
structure. This is currently the case but might change in the future,
so use to_delayed_work() instead, which doesn't make such an
assumption.

linux-2.6.30-rc1 has the to_delayed_work() function that will allow
this patch to work

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
drivers/edac/edac_device.c |    2 +-
drivers/edac/edac_mc.c     |    2 +-
drivers/edac/edac_pci.c    |    2 +-
3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.30-rc1/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.30-rc1.orig/drivers/edac/edac_device.c
+++ linux-2.6.30-rc1/drivers/edac/edac_device.c
@@ -389,7 +389,7 @@ static void del_edac_device_from_global_
  */
 static void edac_device_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
 
 	mutex_lock(&device_ctls_mutex);
Index: linux-2.6.30-rc1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.30-rc1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.30-rc1/drivers/edac/edac_mc.c
@@ -260,7 +260,7 @@ static int edac_mc_assert_error_check_an
  */
 static void edac_mc_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
 
 	mutex_lock(&mem_ctls_mutex);
Index: linux-2.6.30-rc1/drivers/edac/edac_pci.c
===================================================================
--- linux-2.6.30-rc1.orig/drivers/edac/edac_pci.c
+++ linux-2.6.30-rc1/drivers/edac/edac_pci.c
@@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(edac_pci_find);
  */
 static void edac_pci_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct edac_pci_ctl_info *pci = to_edac_pci_ctl_work(d_work);
 	int msec;
 	unsigned long delay;
