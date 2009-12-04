Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbZLDWb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbZLDWb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbZLDWb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:31:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbZLDWb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:31:57 -0500
Message-ID: <4B198E4C.9050602@gmail.com>
Date: Fri, 04 Dec 2009 23:33:48 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: jason.wessel@windriver.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 17/31] Constify struct kgdb_io for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct kgdb_io.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/misc/kgdbts.c   |    4 ++--
 drivers/serial/kgdboc.c |    4 ++--
 include/linux/kgdb.h    |   18 +++++++++---------
 kernel/kgdb.c           |    6 +++---
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index e4ff50b..4cc3f04 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -118,7 +118,7 @@
 	} while (0)
 #define MAX_CONFIG_LEN		40
 
-static struct kgdb_io kgdbts_io_ops;
+static const struct kgdb_io kgdbts_io_ops;
 static char get_buf[BUFMAX];
 static int get_buf_cnt;
 static char put_buf[BUFMAX];
@@ -1102,7 +1102,7 @@ static void kgdbts_post_exp_handler(void)
 		module_put(THIS_MODULE);
 }
 
-static struct kgdb_io kgdbts_io_ops = {
+static const struct kgdb_io kgdbts_io_ops = {
 	.name			= "kgdbts",
 	.read_char		= kgdbts_get_char,
 	.write_char		= kgdbts_put_char,
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index eadc1ab..2d81457 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -18,7 +18,7 @@
 
 #define MAX_CONFIG_LEN		40
 
-static struct kgdb_io		kgdboc_io_ops;
+static const struct kgdb_io	kgdboc_io_ops;
 
 /* -1 = init not run yet, 0 = unconfigured, 1 = configured. */
 static int configured		= -1;
@@ -154,7 +154,7 @@ static void kgdboc_post_exp_handler(void)
 		module_put(THIS_MODULE);
 }
 
-static struct kgdb_io kgdboc_io_ops = {
+static const struct kgdb_io kgdboc_io_ops = {
 	.name			= "kgdboc",
 	.read_char		= kgdboc_get_char,
 	.write_char		= kgdboc_put_char,
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6adcc29..ba61222 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -251,20 +251,20 @@ struct kgdb_arch {
  */
 struct kgdb_io {
 	const char		*name;
-	int			(*read_char) (void);
-	void			(*write_char) (u8);
-	void			(*flush) (void);
-	int			(*init) (void);
-	void			(*pre_exception) (void);
-	void			(*post_exception) (void);
+	int			(* const read_char) (void);
+	void			(* const write_char) (u8);
+	void			(* const flush) (void);
+	int			(* const init) (void);
+	void			(* const pre_exception) (void);
+	void			(* const post_exception) (void);
 };
 
-extern struct kgdb_arch		arch_kgdb_ops;
+extern struct kgdb_arch	arch_kgdb_ops;
 
 extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
 
-extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
-extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
+extern int kgdb_register_io_module(const struct kgdb_io *local_kgdb_io_ops);
+extern void kgdb_unregister_io_module(const struct kgdb_io *local_kgdb_io_ops);
 
 extern int kgdb_hex2long(char **ptr, unsigned long *long_val);
 extern int kgdb_mem2hex(char *mem, char *buf, int count);
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 9147a31..f9203e4 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -86,7 +86,7 @@ static int			kgdb_io_module_registered;
 /* Guard for recursive entry */
 static int			exception_level;
 
-static struct kgdb_io		*kgdb_io_ops;
+static const struct kgdb_io	*kgdb_io_ops;
 static DEFINE_SPINLOCK(kgdb_registration_lock);
 
 /* kgdb console driver is loaded */
@@ -1637,7 +1637,7 @@ static void kgdb_initial_breakpoint(void)
  *
  *	Register it with the KGDB core.
  */
-int kgdb_register_io_module(struct kgdb_io *new_kgdb_io_ops)
+int kgdb_register_io_module(const struct kgdb_io *new_kgdb_io_ops)
 {
 	int err;
 
@@ -1682,7 +1682,7 @@ EXPORT_SYMBOL_GPL(kgdb_register_io_module);
  *
  *	Unregister it with the KGDB core.
  */
-void kgdb_unregister_io_module(struct kgdb_io *old_kgdb_io_ops)
+void kgdb_unregister_io_module(const struct kgdb_io *old_kgdb_io_ops)
 {
 	BUG_ON(kgdb_connected);
 

