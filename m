Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYHaQcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYHaQcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYHaQba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:31:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:36232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbYHaQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:31:29 -0400
Date: Sun, 31 Aug 2008 09:30:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, tglx@tglx.de, mingo@elte.hu,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/5] select: add a poll specific struct to the restart_block
 union
Message-ID: <20080831093038.5a35e517@infradead.org>
In-Reply-To: <20080831092828.13ae0279@infradead.org>
References: <20080831092828.13ae0279@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 31 Aug 2008 08:19:15 -0700
Subject: [PATCH] select: add a poll specific struct to the restart_block union

with hrtimer poll/select, the signal restart data no longer is a single
long representing a jiffies count, but it becomes a second/nanosecond pair
that also needs to encode if there was a timeout at all or not.

This patch adds a struct to the restart_block union for this purpose

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/thread_info.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 38a5647..e6b820f 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -38,6 +38,14 @@ struct restart_block {
 #endif
 			u64 expires;
 		} nanosleep;
+		/* For poll */
+		struct {
+			struct pollfd __user *ufds;
+			int nfds;
+			int has_timeout;
+			unsigned long tv_sec;
+			unsigned long tv_nsec;
+		} poll;
 	};
 };
 
-- 
1.5.5.1

