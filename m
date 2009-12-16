Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbZLPIJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbZLPIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934681AbZLPIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:09:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1202 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761746AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] kernel.h: printk neatening
Date: Wed, 16 Dec 2009 00:09:04 -0800
Message-Id: <86bb4429e867e5b4de4a07752883ebfa4fdec074.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a few printk elements a bit more consistent
Remove trailing backslashes from static inline prototype
Use fmt and ##__VA_ARGS__ in printk_once
Make statement expressions multiline
Use tabs for #define foo	bar

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   90 ++++++++++++++++++++++++++++--------------------
 1 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 75e7439..f7144b1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -385,10 +385,10 @@ extern const char linux_proc_banner[];
 
 extern int console_printk[];
 
-#define console_loglevel (console_printk[0])
-#define default_message_loglevel (console_printk[1])
-#define minimum_console_loglevel (console_printk[2])
-#define default_console_loglevel (console_printk[3])
+#define console_loglevel		(console_printk[0])
+#define default_message_loglevel	(console_printk[1])
+#define minimum_console_loglevel	(console_printk[2])
+#define default_console_loglevel	(console_printk[3])
 
 /*
  * FW_BUG
@@ -430,12 +430,13 @@ extern int printk_delay_msec;
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
-#define printk_once(x...) ({			\
+#define printk_once(fmt, ...)			\
+({						\
 	static bool __print_once;		\
 						\
 	if (!__print_once) {			\
 		__print_once = true;		\
-		printk(x);			\
+		printk(fmt, ##__VA_ARGS__);	\
 	}					\
 })
 
@@ -448,12 +449,14 @@ static inline int printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
 static inline int printk_ratelimit(void) { return 0; }
-static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
-					  unsigned int interval_msec)	\
-		{ return false; }
+static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+					  unsigned int interval_msec)
+{
+	return false;
+}
 
 /* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(x...) printk(x)
+#define printk_once(fmt, ...) printk(fmt, ##__VA_ARGS__)
 
 static inline void log_buf_kexec_setup(void)
 {
@@ -506,43 +509,51 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define pr_fmt(fmt) fmt
 #endif
 
-#define pr_emerg(fmt, ...) \
+#define pr_emerg(fmt, ...)				\
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert(fmt, ...) \
+#define pr_alert(fmt, ...)				\
 	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit(fmt, ...) \
+#define pr_crit(fmt, ...)				\
 	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err(fmt, ...) \
+#define pr_err(fmt, ...)				\
 	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
+#define pr_warning(fmt, ...)				\
 	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_notice(fmt, ...) \
+#define pr_notice(fmt, ...)				\
 	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
+#define pr_info(fmt, ...)				\
 	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_cont(fmt, ...) \
+#define pr_cont(fmt, ...)				\
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
-#define pr_devel(fmt, ...) \
+#define pr_devel(fmt, ...)				\
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
-#define pr_devel(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#define pr_devel(fmt, ...)					\
+({								\
+	if (0)							\
+		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
+	0;							\
+})
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
-#define pr_debug(fmt, ...) \
+#define pr_debug(fmt, ...)				\
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
-#define pr_debug(fmt, ...) \
+#define pr_debug(fmt, ...)				\
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
 #else
-#define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#define pr_debug(fmt, ...)					\
+({								\
+	if (0)							\
+		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
+	0;							\
+})
 #endif
 
 /*
@@ -550,7 +561,8 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
  * no local ratelimit_state used in the !PRINTK case
  */
 #ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({		\
+#define printk_ratelimited(fmt, ...)			\
+({							\
 	static struct ratelimit_state _rs = {		\
 		.interval = DEFAULT_RATELIMIT_INTERVAL, \
 		.burst = DEFAULT_RATELIMIT_BURST,       \
@@ -564,29 +576,33 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define printk_ratelimited printk
 #endif
 
-#define pr_emerg_ratelimited(fmt, ...) \
+#define pr_emerg_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert_ratelimited(fmt, ...) \
+#define pr_alert_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit_ratelimited(fmt, ...) \
+#define pr_crit_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err_ratelimited(fmt, ...) \
+#define pr_err_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning_ratelimited(fmt, ...) \
+#define pr_warning_ratelimited(fmt, ...)				\
 	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_notice_ratelimited(fmt, ...) \
+#define pr_notice_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info_ratelimited(fmt, ...) \
+#define pr_info_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
-#define pr_debug_ratelimited(fmt, ...) \
+#define pr_debug_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
-#define pr_debug_ratelimited(fmt, ...) \
-	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
-				     ##__VA_ARGS__); 0; })
+#define pr_debug_ratelimited(fmt, ...)					\
+({									\
+	if (0)								\
+		printk_ratelimited(KERN_DEBUG pr_fmt(fmt),		\
+				   ##__VA_ARGS__);			\
+	0;								\
+})
 #endif
 
 /*
-- 
1.6.6.rc0.57.gad7a

