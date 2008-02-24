Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYBXSCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYBXSCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbYBXSCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:02:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45706 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbYBXSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:02:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Feb 2008 19:00:51 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/5] firewire: fw-sbp2: fix reference counting
To: linux1394-devel@lists.sourceforge.net
cc: Kristian Hoegsberg <krh@bitplanet.net>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
Message-ID: <tkrat.629a01ec0da48fe0@s5r6.in-berlin.de>
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reference count of the unit dropped too low in an error path in
sbp2_probe.  Fixed by moving the _get further up.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1083,6 +1083,7 @@ static int sbp2_probe(struct device *dev
 		goto fail_shost_put;
 
 	fw_device_get(device);
+	get_device(&unit->device);
 
 	/* Initialize to values that won't match anything in our table. */
 	firmware_revision = 0xff000000;
@@ -1098,8 +1099,6 @@ static int sbp2_probe(struct device *dev
 
 	sbp2_init_workarounds(tgt, model, firmware_revision);
 
-	get_device(&unit->device);
-
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
 		sbp2_queue_work(lu, 0);

-- 
Stefan Richter
-=====-==--- --=- ==---
http://arcgraph.de/sr/

