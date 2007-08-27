Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXH0Vjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXH0Vjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764659AbXH0V3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58863 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932180AbXH0V3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:06 -0400
Date: Mon, 27 Aug 2007 23:29:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make kernel/profile.c:time_hook static
Message-ID: <20070827212905.GE26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

{,un}register_timer_hook() is the API that should be used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Aug 2007

 include/linux/profile.h |    3 ---
 kernel/profile.c        |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

eb5ee2402ed38bdaa3587d01a0ec3e80d5d1e438 
diff --git a/include/linux/profile.h b/include/linux/profile.h
index eec48f5..ff576d1 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -78,9 +78,6 @@ int profile_event_unregister(enum profile_type, struct notifier_block * n);
 int register_timer_hook(int (*hook)(struct pt_regs *));
 void unregister_timer_hook(int (*hook)(struct pt_regs *));
 
-/* Timer based profiling hook */
-extern int (*timer_hook)(struct pt_regs *);
-
 struct pt_regs;
 
 #else
diff --git a/kernel/profile.c b/kernel/profile.c
index ed407f5..fa3ee33 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -37,7 +37,7 @@ struct profile_hit {
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
 /* Oprofile timer tick hook */
-int (*timer_hook)(struct pt_regs *) __read_mostly;
+static int (*timer_hook)(struct pt_regs *) __read_mostly;
 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;

