Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab0CKQWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:22:08 -0500
Received: from smtp.nokia.com ([192.100.122.230]:24833 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab0CKQWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:22:03 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: giometti@linux.it, vegard.nossum@gmail.com, akpm@linux-foundation.org,
       ext-jani.1.nikula@nokia.com
Subject: [PATCH] c2port: fix device_create() return value check
Date: Thu, 11 Mar 2010 18:20:52 +0200
Message-Id: <1268324452-30589-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 11 Mar 2010 16:21:01.0342 (UTC) FILETIME=[D706C3E0:01CAC136]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Use IS_ERR() instead of comparing to NULL.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>

---

NOTE: I'm afraid I'm unable to test this; please consider this more a
bug report than a complete patch.
---
 drivers/misc/c2port/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index b5346b4..3276216 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -912,7 +912,7 @@ struct c2port_device *c2port_device_register(char *name,
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 					"c2port%d", id);
-	if (unlikely(!c2dev->dev)) {
+	if (unlikely(IS_ERR(c2dev->dev))) {
 		ret = -ENOMEM;
 		goto error_device_create;
 	}
-- 
1.6.5.2

