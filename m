Return-Path: <linux-kernel-owner+w=401wt.eu-S936708AbXJSTv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936708AbXJSTv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935826AbXJSTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:50:07 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24616 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933798AbXJSTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:50:00 -0400
Date: Fri, 19 Oct 2007 13:17:03 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/8] drivers-edac-use round_jiffies_relative
Message-ID: <471902af.TPH07pfs5gbz7c2B%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

When rounding a relative timeout we need to use round_jiffies_relative(). 

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
CC:     Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---

Index: linux-2.6.23/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.23.orig/drivers/edac/edac_device.c
+++ linux-2.6.23/drivers/edac/edac_device.c
@@ -440,7 +440,7 @@ static void edac_device_workq_function(s
 	 */
 	if (edac_dev->poll_msec == 1000)
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
-				round_jiffies(edac_dev->delay));
+				round_jiffies_relative(edac_dev->delay));
 	else
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
 				edac_dev->delay);
@@ -472,7 +472,7 @@ void edac_device_workq_setup(struct edac
 	 */
 	if (edac_dev->poll_msec == 1000)
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
-				round_jiffies(edac_dev->delay));
+				round_jiffies_relative(edac_dev->delay));
 	else
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
 				edac_dev->delay);
Index: linux-2.6.23/drivers/edac/edac_pci.c
===================================================================
--- linux-2.6.23.orig/drivers/edac/edac_pci.c
+++ linux-2.6.23/drivers/edac/edac_pci.c
@@ -246,7 +246,7 @@ static void edac_pci_workq_function(stru
 		/* if we are on a one second period, then use round */
 		msec = edac_pci_get_poll_msec();
 		if (msec == 1000)
-			delay = round_jiffies(msecs_to_jiffies(msec));
+			delay = round_jiffies_relative(msecs_to_jiffies(msec));
 		else
 			delay = msecs_to_jiffies(msec);
 
