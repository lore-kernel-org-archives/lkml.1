Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbYGaCyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbYGaCyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759348AbYGaCt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:49:57 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60565 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986AbYGaCty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:49:54 -0400
Date: Wed, 30 Jul 2008 21:48:54 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 9/30] W1: new module parameter search_count
Message-ID: <20080731024854.GJ12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:48:54 -0500 (CDT)
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
