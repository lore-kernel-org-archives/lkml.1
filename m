Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbYBTNuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbYBTNuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762663AbYBTNrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:47:49 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47679 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbYBTNrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:47:22 -0500
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [RFC PATCH 5/8] [NET]: uninline dst_release
Date: Wed, 20 Feb 2008 15:47:15 +0200
Message-Id: <1203515238-22848-6-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Codiff stats:
-16420  187 funcs, 103 +, 16523 -, diff: -16420 --- dst_release

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/net/dst.h |   10 +---------
 net/core/dst.c    |   10 ++++++++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index e3ac7d0..bf33471 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -158,15 +158,7 @@ struct dst_entry * dst_clone(struct dst_entry * dst)
 	return dst;
 }
 
-static inline
-void dst_release(struct dst_entry * dst)
-{
-	if (dst) {
-		WARN_ON(atomic_read(&dst->__refcnt) < 1);
-		smp_mb__before_atomic_dec();
-		atomic_dec(&dst->__refcnt);
-	}
-}
+extern void dst_release(struct dst_entry *dst);
 
 /* Children define the path of the packet through the
  * Linux networking.  Thus, destinations are stackable.
diff --git a/net/core/dst.c b/net/core/dst.c
index 7deef48..cc2e724 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -259,6 +259,16 @@ again:
 	return NULL;
 }
 
+void dst_release(struct dst_entry *dst)
+{
+	if (dst) {
+		WARN_ON(atomic_read(&dst->__refcnt) < 1);
+		smp_mb__before_atomic_dec();
+		atomic_dec(&dst->__refcnt);
+	}
+}
+EXPORT_SYMBOL(dst_release);
+
 /* Dirty hack. We did it in 2.2 (in __dst_free),
  * we have _very_ good reasons not to repeat
  * this mistake in 2.3, but we have no choice
-- 
1.5.2.2

