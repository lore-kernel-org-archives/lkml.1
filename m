Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZDAKvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZDAKvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZDAKuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:50:23 -0400
Received: from ozlabs.org ([203.10.76.45]:38004 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbZDAKuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:50:20 -0400
Date: Wed, 1 Apr 2009 21:46:33 +1100
From: Anton Blanchard <anton@samba.org>
To: linux-kernel@vger.kernel.org
Cc: arjan@infradead.org, akpm@osdl.org
Subject: [PATCH] Align rekey_work
Message-ID: <20090401104633.GH27084@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Align rekey_work. Even though it's infrequent, we may as well line it up.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c	2009-04-01 15:47:27.000000000 +1100
+++ linux-2.6/drivers/char/random.c	2009-04-01 16:32:40.000000000 +1100
@@ -1488,7 +1488,8 @@
 	keyptr->count = (ip_cnt & COUNT_MASK) << HASH_BITS;
 	smp_wmb();
 	ip_cnt++;
-	schedule_delayed_work(&rekey_work, REKEY_INTERVAL);
+	schedule_delayed_work(&rekey_work,
+			      round_jiffies_relative(REKEY_INTERVAL));
 }
 
 static inline struct keydata *get_keyptr(void)
