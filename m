Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYKZAfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYKZAfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKZAfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:35:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39000 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYKZAfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:35:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 26 Nov 2008 01:34:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: replace a GFP_ATOMIC by GFP_KERNEL allocation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f8f7746d95c4ceee@s5r6.in-berlin.de>
Message-ID: <tkrat.0159ca29740012a7@s5r6.in-berlin.de>
References: <tkrat.f8f7746d95c4ceee@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers of hpsb_register_addrspace() can sleep.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/highlevel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/ieee1394/highlevel.c
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.c
+++ linux/drivers/ieee1394/highlevel.c
@@ -420,7 +420,7 @@ int hpsb_register_addrspace(struct hpsb_
 		return 0;
 	}
 
-	as = kmalloc(sizeof(*as), GFP_ATOMIC);
+	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (!as)
 		return 0;
 

-- 
Stefan Richter
-=====-==--- =-== ==-=-
http://arcgraph.de/sr/

