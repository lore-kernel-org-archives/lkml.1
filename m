Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbYGKNvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbYGKNvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbYGKNsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:01 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34978 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758987AbYGKNrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:52 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 9/30] W1: new module parameter search_count
Date: Fri, 11 Jul 2008 17:51:24 +0400
Message-Id: <1215784306334-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new module parameter search_count which allows overriding the
default search count.  -1 continual, 0 disabled, N that many times.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/w1_int.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 9d723ef..3fd6e66 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -30,6 +30,8 @@
 #include "w1_int.h"
 
 static u32 w1_ids = 1;
+static int w1_search_count = -1; /* Default is continual scan */
+module_param_named(search_count, w1_search_count, int, 0);
 
 static int w1_enable_pullup = 1;
 module_param_named(enable_pullup, w1_enable_pullup, int, 0);
@@ -62,8 +64,8 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	dev->initialized	= 0;
 	dev->id			= id;
 	dev->slave_ttl		= slave_ttl;
+	dev->search_count	= w1_search_count;
 	dev->enable_pullup	= w1_enable_pullup;
-        dev->search_count	= -1; /* continual scan */
 
 	/* 1 for w1_process to decrement
 	 * 1 for __w1_remove_master_device to decrement
-- 
1.4.4.4

