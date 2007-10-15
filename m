Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbXJOFgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbXJOFgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXJOFgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:36:39 -0400
Received: from ozlabs.org ([203.10.76.45]:50386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXJOFgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:36:39 -0400
Date: Mon, 15 Oct 2007 00:34:28 -0500
From: Anton Blanchard <anton@samba.org>
To: dougthompson@xmission.com
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH] jiffies_round -> jiffies_round_relative conversion in EDAC
	drivers
Message-ID: <20071015053428.GA3257@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When rounding a relative timeout we need to use round_jiffies_relative(). 

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index f3690a6..46400ec 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -436,7 +436,7 @@ static void edac_device_workq_function(struct work_struct *work_req)
 	 */
 	if (edac_dev->poll_msec == 1000)
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
-				round_jiffies(edac_dev->delay));
+				round_jiffies_relative(edac_dev->delay));
 	else
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
 				edac_dev->delay);
@@ -468,7 +468,7 @@ void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 	 */
 	if (edac_dev->poll_msec == 1000)
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
-				round_jiffies(edac_dev->delay));
+				round_jiffies_relative(edac_dev->delay));
 	else
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
 				edac_dev->delay);
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 5dee9f5..7573e07 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -246,7 +246,7 @@ static void edac_pci_workq_function(struct work_struct *work_req)
 		/* if we are on a one second period, then use round */
 		msec = edac_pci_get_poll_msec();
 		if (msec == 1000)
-			delay = round_jiffies(msecs_to_jiffies(msec));
+			delay = round_jiffies_relative(msecs_to_jiffies(msec));
 		else
 			delay = msecs_to_jiffies(msec);
 
