Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYJULUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYJULUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYJULT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:19:59 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:2267 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597AbYJULT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:19:58 -0400
Date: Tue, 21 Oct 2008 20:19:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] profiling: Fix up CONFIG_PROC_FS=n build.
Message-ID: <20081021111936.GA2204@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case where procfs is disabled, create_proc_profile() does not
exist. Stub it in with the others.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/linux/profile.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/profile.h b/include/linux/profile.h
index 5700450..a0fc322 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -19,10 +19,16 @@ struct notifier_block;
 
 #if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
 void create_prof_cpu_mask(struct proc_dir_entry *de);
+int create_proc_profile(void);
 #else
 static inline void create_prof_cpu_mask(struct proc_dir_entry *de)
 {
 }
+
+static inline int create_proc_profile(void)
+{
+	return 0;
+}
 #endif
 
 enum profile_type {
@@ -37,7 +43,6 @@ extern int prof_on __read_mostly;
 /* init basic kernel profiler */
 int profile_init(void);
 int profile_setup(char *str);
-int create_proc_profile(void);
 void profile_tick(int type);
 
 /*
