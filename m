Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZDAKub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZDAKub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZDAKuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:50:19 -0400
Received: from ozlabs.org ([203.10.76.45]:38005 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZDAKuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:50:19 -0400
Date: Wed, 1 Apr 2009 21:45:18 +1100
From: Anton Blanchard <anton@samba.org>
To: linux-kernel@vger.kernel.org
Cc: arjan@infradead.org, akpm@osdl.org
Subject: [PATCH] Align cache_clean work
Message-ID: <20090401104518.GG27084@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Align cache_clean work.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/net/sunrpc/cache.c
===================================================================
--- linux-2.6.orig/net/sunrpc/cache.c	2009-04-01 15:47:38.000000000 +1100
+++ linux-2.6/net/sunrpc/cache.c	2009-04-01 16:32:44.000000000 +1100
@@ -488,7 +488,7 @@
 {
 	int delay = 5;
 	if (cache_clean() == -1)
-		delay = 30*HZ;
+		delay = round_jiffies_relative(30*HZ);
 
 	if (list_empty(&cache_list))
 		delay = 0;
