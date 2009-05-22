Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZEVE15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZEVE15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZEVE1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:27:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2899 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZEVE1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:27:34 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH V2 1/3] kernel.h: Add DO_ONCE statement expression macro
Date: Thu, 21 May 2009 21:27:30 -0700
Message-Id: <7d398b6a4a3b57255097e79c24952cb586bfc7de.1242965307.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242965306.git.joe@perches.com>
References: <cover.1242965306.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DO_ONCE statement expression analogous to printk_once
that executes any arbitrary statement exactly once.

This will take the place of printk_once so that
DO_ONCE(pr_<foo>) can be more easily written.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..179fdac 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -637,6 +637,17 @@ static inline void ftrace_dump(void) { }
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Do something once (analogous to WARN_ONCE() et al):
+ */
+#define DO_ONCE(x...) ({			\
+	static unsigned long __done;		\
+						\
+	if (!test_and_set_bit(0, &__done)) {	\
+		x;				\
+	}					\
+})
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  * @ptr:	the pointer to the member.
-- 
1.6.3.1.10.g659a0.dirty

