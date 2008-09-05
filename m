Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYIEOhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYIEOhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYIEOhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:37:40 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56096 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYIEOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:37:39 -0400
From: Hannes Hering <hannes.hering@gmx.de>
Subject: [PATCH 1/2] ehea: Fix DLPAR memory handling
Date: Fri, 5 Sep 2008 16:36:26 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200809051636.26545.hannes.hering@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ehea busmap must be allocated only once in the first of many calls of the
ehea_create_busmap_callback.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
---

diff -Nurp -X dontdiff linux-2.6.27-rc5/drivers/net/ehea/ehea_qmr.c patched_kernel/drivers/net/ehea/ehea_qmr.c
--- linux-2.6.27-rc5/drivers/net/ehea/ehea_qmr.c	2008-08-29 00:52:02.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea_qmr.c	2008-09-05 15:31:30.000000000 +0200
@@ -595,7 +595,8 @@ static int ehea_create_busmap_callback(u
 	end_section = start_section + ((nr_pages * PAGE_SIZE) / EHEA_SECTSIZE);
 	mr_len = *(unsigned long *)arg;
 
-	ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
+	if (!ehea_bmap)
+		ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
 	if (!ehea_bmap)
 		return -ENOMEM;
 
