Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZJNGDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZJNGDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZJNGDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZJNGDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:30 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] percpu: make alloc_percpu() handle array types
Date: Wed, 14 Oct 2009 15:01:51 +0900
Message-Id: <1255500125-3210-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_percpu() couldn't handle array types like "int [100]" due to the
way return type was casted.  Fix it by using typeof() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 3d9ba92..519d687 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -164,8 +164,8 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
 
 #endif /* CONFIG_SMP */
 
-#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
-						       __alignof__(type))
+#define alloc_percpu(type)	\
+	(typeof(type) *)__alloc_percpu(sizeof(type), __alignof__(type))
 
 /*
  * Optional methods for optimized non-lvalue per-cpu variable access.
-- 
1.6.4.2

