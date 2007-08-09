Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbXHITv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbXHITv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXHITvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:51:51 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53033 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbXHITvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:51:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: [PATCH 1/3] sysctl core: Stop using the unnecessary ctl_table typedef
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
Date: Thu, 09 Aug 2007 13:50:51 -0600
In-Reply-To: <20070806124530.GD6634@localhost.sw.ru> (Alexey Dobriyan's
	message of "Mon, 6 Aug 2007 16:45:31 +0400")
Message-ID: <m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In sysctl.h the typedef struct ctl_table ctl_table violates coding
style isn't needed and is a bit of a nuisance because it makes it
harder to recognize ctl_table is a type name.

So this patch removes it from the generic sysctl code.  Hopefully
I will have enough energy to send the rest of my patches will follow
and to remove it from the rest of the kernel. 

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sysctl.h |   36 ++++++++--------
 kernel/sysctl.c        |  114 ++++++++++++++++++++++++------------------------
 2 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 483050c..f73be4c 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -937,37 +937,37 @@ extern int sysctl_perm(struct ctl_table *table, int op);
 
 typedef struct ctl_table ctl_table;
 
-typedef int ctl_handler (ctl_table *table, int __user *name, int nlen,
+typedef int ctl_handler (struct ctl_table *table, int __user *name, int nlen,
 			 void __user *oldval, size_t __user *oldlenp,
 			 void __user *newval, size_t newlen);
 
-typedef int proc_handler (ctl_table *ctl, int write, struct file * filp,
+typedef int proc_handler (struct ctl_table *ctl, int write, struct file * filp,
 			  void __user *buffer, size_t *lenp, loff_t *ppos);
 
-extern int proc_dostring(ctl_table *, int, struct file *,
+extern int proc_dostring(struct ctl_table *, int, struct file *,
 			 void __user *, size_t *, loff_t *);
-extern int proc_dointvec(ctl_table *, int, struct file *,
+extern int proc_dointvec(struct ctl_table *, int, struct file *,
 			 void __user *, size_t *, loff_t *);
-extern int proc_dointvec_bset(ctl_table *, int, struct file *,
+extern int proc_dointvec_bset(struct ctl_table *, int, struct file *,
 			      void __user *, size_t *, loff_t *);
-extern int proc_dointvec_minmax(ctl_table *, int, struct file *,
+extern int proc_dointvec_minmax(struct ctl_table *, int, struct file *,
 				void __user *, size_t *, loff_t *);
-extern int proc_dointvec_jiffies(ctl_table *, int, struct file *,
+extern int proc_dointvec_jiffies(struct ctl_table *, int, struct file *,
 				 void __user *, size_t *, loff_t *);
-extern int proc_dointvec_userhz_jiffies(ctl_table *, int, struct file *,
+extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
-extern int proc_dointvec_ms_jiffies(ctl_table *, int, struct file *,
+extern int proc_dointvec_ms_jiffies(struct ctl_table *, int, struct file *,
 				    void __user *, size_t *, loff_t *);
-extern int proc_doulongvec_minmax(ctl_table *, int, struct file *,
+extern int proc_doulongvec_minmax(struct ctl_table *, int, struct file *,
 				  void __user *, size_t *, loff_t *);
-extern int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int,
+extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      struct file *, void __user *, size_t *, loff_t *);
 
 extern int do_sysctl (int __user *name, int nlen,
 		      void __user *oldval, size_t __user *oldlenp,
 		      void __user *newval, size_t newlen);
 
-extern int do_sysctl_strategy (ctl_table *table, 
+extern int do_sysctl_strategy (struct ctl_table *table,
 			       int __user *name, int nlen,
 			       void __user *oldval, size_t __user *oldlenp,
 			       void __user *newval, size_t newlen);
@@ -980,7 +980,7 @@ extern ctl_handler sysctl_ms_jiffies;
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
- * with an initialised array of ctl_table's.  An entry with zero
+ * with an initialised array of struct ctl_table's.  An entry with zero
  * ctl_name and NULL procname terminates the table.  table->de will be
  * set up by the registration and need not be initialised in advance.
  *
@@ -1026,8 +1026,8 @@ struct ctl_table
 	void *data;
 	int maxlen;
 	mode_t mode;
-	ctl_table *child;
-	ctl_table *parent;		/* Automatically set */
+	struct ctl_table *child;
+	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	ctl_handler *strategy;		/* Callback function for all r/w */
 	void *extra1;
@@ -1035,16 +1035,16 @@ struct ctl_table
 };
 
 /* struct ctl_table_header is used to maintain dynamic lists of
-   ctl_table trees. */
+   struct ctl_table trees. */
 struct ctl_table_header
 {
-	ctl_table *ctl_table;
+	struct ctl_table *ctl_table;
 	struct list_head ctl_entry;
 	int used;
 	struct completion *unregistering;
 };
 
-struct ctl_table_header * register_sysctl_table(ctl_table * table);
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
 
 void unregister_sysctl_table(struct ctl_table_header * table);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 79c891e..6723f92 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -129,32 +129,32 @@ extern int max_lock_depth;
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 static int parse_table(int __user *, int, void __user *, size_t __user *,
-		void __user *, size_t, ctl_table *);
+		void __user *, size_t, struct ctl_table *);
 #endif
 
 
 #ifdef CONFIG_PROC_SYSCTL
-static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
+static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
-static ctl_table root_table[];
+static struct ctl_table root_table[];
 static struct ctl_table_header root_table_header =
 	{ root_table, LIST_HEAD_INIT(root_table_header.ctl_entry) };
 
-static ctl_table kern_table[];
-static ctl_table vm_table[];
-static ctl_table fs_table[];
-static ctl_table debug_table[];
-static ctl_table dev_table[];
-extern ctl_table random_table[];
+static struct ctl_table kern_table[];
+static struct ctl_table vm_table[];
+static struct ctl_table fs_table[];
+static struct ctl_table debug_table[];
+static struct ctl_table dev_table[];
+extern struct ctl_table random_table[];
 #ifdef CONFIG_UNIX98_PTYS
-extern ctl_table pty_table[];
+extern struct ctl_table pty_table[];
 #endif
 #ifdef CONFIG_INOTIFY_USER
-extern ctl_table inotify_table[];
+extern struct ctl_table inotify_table[];
 #endif
 
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
@@ -166,7 +166,7 @@ extern int lock_stat;
 
 /* The default sysctl tables: */
 
-static ctl_table root_table[] = {
+static struct ctl_table root_table[] = {
 	{
 		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
@@ -219,7 +219,7 @@ static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
 static unsigned long max_wakeup_granularity_ns = 1000000000;	/* 1 second */
 #endif
 
-static ctl_table kern_table[] = {
+static struct ctl_table kern_table[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -762,7 +762,7 @@ static int two = 2;
 static int one_hundred = 100;
 
 
-static ctl_table vm_table[] = {
+static struct ctl_table vm_table[] = {
 	{
 		.ctl_name	= VM_OVERCOMMIT_MEMORY,
 		.procname	= "overcommit_memory",
@@ -1056,12 +1056,12 @@ static ctl_table vm_table[] = {
 };
 
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
-static ctl_table binfmt_misc_table[] = {
+static struct ctl_table binfmt_misc_table[] = {
 	{ .ctl_name = 0 }
 };
 #endif
 
-static ctl_table fs_table[] = {
+static struct ctl_table fs_table[] = {
 	{
 		.ctl_name	= FS_NRINODE,
 		.procname	= "inode-nr",
@@ -1202,7 +1202,7 @@ static ctl_table fs_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table debug_table[] = {
+static struct ctl_table debug_table[] = {
 #ifdef CONFIG_X86
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1216,7 +1216,7 @@ static ctl_table debug_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table dev_table[] = {
+static struct ctl_table dev_table[] = {
 	{ .ctl_name = 0 }
 };
 
@@ -1356,7 +1356,7 @@ static int test_perm(int mode, int op)
 	return -EACCES;
 }
 
-int sysctl_perm(ctl_table *table, int op)
+int sysctl_perm(struct ctl_table *table, int op)
 {
 	int error;
 	error = security_sysctl(table, op);
@@ -1369,7 +1369,7 @@ int sysctl_perm(ctl_table *table, int op)
 static int parse_table(int __user *name, int nlen,
 		       void __user *oldval, size_t __user *oldlenp,
 		       void __user *newval, size_t newlen,
-		       ctl_table *table)
+		       struct ctl_table *table)
 {
 	int n;
 repeat:
@@ -1400,7 +1400,7 @@ repeat:
 }
 
 /* Perform the actual read/write of a sysctl table entry. */
-int do_sysctl_strategy (ctl_table *table, 
+int do_sysctl_strategy (struct ctl_table *table,
 			int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
@@ -1475,7 +1475,7 @@ core_initcall(sysctl_init);
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. An entry with a ctl_name of 0 terminates the table. 
  *
- * The members of the &ctl_table structure are used as follows:
+ * The members of the &struct ctl_table structure are used as follows:
  *
  * ctl_name - This is the numeric sysctl value used by sysctl(2). The number
  *            must be unique within that level of sysctl
@@ -1536,7 +1536,7 @@ core_initcall(sysctl_init);
  * This routine returns %NULL on a failure to register, and a pointer
  * to the table header on success.
  */
-struct ctl_table_header *register_sysctl_table(ctl_table * table)
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
 {
 	struct ctl_table_header *tmp;
 	tmp = kmalloc(sizeof(struct ctl_table_header), GFP_KERNEL);
@@ -1570,7 +1570,7 @@ void unregister_sysctl_table(struct ctl_table_header * header)
 }
 
 #else /* !CONFIG_SYSCTL */
-struct ctl_table_header *register_sysctl_table(ctl_table * table)
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
 {
 	return NULL;
 }
@@ -1663,7 +1663,7 @@ static int _proc_do_string(void* data, int maxlen, int write,
  *
  * Returns 0 on success.
  */
-int proc_dostring(ctl_table *table, int write, struct file *filp,
+int proc_dostring(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return _proc_do_string(table->data, table->maxlen, write, filp,
@@ -1690,7 +1690,7 @@ static int do_proc_dointvec_conv(int *negp, unsigned long *lvalp,
 	return 0;
 }
 
-static int __do_proc_dointvec(void *tbl_data, ctl_table *table,
+static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		  int write, struct file *filp, void __user *buffer,
 		  size_t *lenp, loff_t *ppos,
 		  int (*conv)(int *negp, unsigned long *lvalp, int *valp,
@@ -1800,7 +1800,7 @@ static int __do_proc_dointvec(void *tbl_data, ctl_table *table,
 #undef TMPBUFLEN
 }
 
-static int do_proc_dointvec(ctl_table *table, int write, struct file *filp,
+static int do_proc_dointvec(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos,
 		  int (*conv)(int *negp, unsigned long *lvalp, int *valp,
 			      int write, void *data),
@@ -1824,7 +1824,7 @@ static int do_proc_dointvec(ctl_table *table, int write, struct file *filp,
  *
  * Returns 0 on success.
  */
-int proc_dointvec(ctl_table *table, int write, struct file *filp,
+int proc_dointvec(struct ctl_table *table, int write, struct file *filp,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
@@ -1864,7 +1864,7 @@ static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
  *	init may raise the set.
  */
  
-int proc_dointvec_bset(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_bset(struct ctl_table *table, int write, struct file *filp,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int op;
@@ -1881,7 +1881,7 @@ int proc_dointvec_bset(ctl_table *table, int write, struct file *filp,
 /*
  *	Taint values can only be increased
  */
-static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int op;
@@ -1940,7 +1940,7 @@ static int do_proc_dointvec_minmax_conv(int *negp, unsigned long *lvalp,
  *
  * Returns 0 on success.
  */
-int proc_dointvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_minmax(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct do_proc_dointvec_minmax_conv_param param = {
@@ -1951,7 +1951,7 @@ int proc_dointvec_minmax(ctl_table *table, int write, struct file *filp,
 				do_proc_dointvec_minmax_conv, &param);
 }
 
-static int __do_proc_doulongvec_minmax(void *data, ctl_table *table, int write,
+static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     struct file *filp,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
@@ -2056,7 +2056,7 @@ static int __do_proc_doulongvec_minmax(void *data, ctl_table *table, int write,
 #undef TMPBUFLEN
 }
 
-static int do_proc_doulongvec_minmax(ctl_table *table, int write,
+static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 				     struct file *filp,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
@@ -2084,7 +2084,7 @@ static int do_proc_doulongvec_minmax(ctl_table *table, int write,
  *
  * Returns 0 on success.
  */
-int proc_doulongvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_doulongvec_minmax(struct ctl_table *table, int write, struct file *filp,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos, 1l, 1l);
@@ -2108,7 +2108,7 @@ int proc_doulongvec_minmax(ctl_table *table, int write, struct file *filp,
  *
  * Returns 0 on success.
  */
-int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int write,
+int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 				      struct file *filp,
 				      void __user *buffer,
 				      size_t *lenp, loff_t *ppos)
@@ -2201,7 +2201,7 @@ static int do_proc_dointvec_ms_jiffies_conv(int *negp, unsigned long *lvalp,
  *
  * Returns 0 on success.
  */
-int proc_dointvec_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_jiffies(struct ctl_table *table, int write, struct file *filp,
 			  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
@@ -2224,7 +2224,7 @@ int proc_dointvec_jiffies(ctl_table *table, int write, struct file *filp,
  *
  * Returns 0 on success.
  */
-int proc_dointvec_userhz_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file *filp,
 				 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
@@ -2248,14 +2248,14 @@ int proc_dointvec_userhz_jiffies(ctl_table *table, int write, struct file *filp,
  *
  * Returns 0 on success.
  */
-int proc_dointvec_ms_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_ms_jiffies(struct ctl_table *table, int write, struct file *filp,
 			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return do_proc_dointvec(table, write, filp, buffer, lenp, ppos,
 				do_proc_dointvec_ms_jiffies_conv, NULL);
 }
 
-static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
+static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct pid *new_pid;
@@ -2279,55 +2279,55 @@ static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
 
 #else /* CONFIG_PROC_FS */
 
-int proc_dostring(ctl_table *table, int write, struct file *filp,
+int proc_dostring(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec(ctl_table *table, int write, struct file *filp,
+int proc_dointvec(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_bset(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_bset(struct ctl_table *table, int write, struct file *filp,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_minmax(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_jiffies(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_userhz_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_ms_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_ms_jiffies(struct ctl_table *table, int write, struct file *filp,
 			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_doulongvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_doulongvec_minmax(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int write,
+int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 				      struct file *filp,
 				      void __user *buffer,
 				      size_t *lenp, loff_t *ppos)
@@ -2345,7 +2345,7 @@ int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int write,
  */
 
 /* The generic string strategy routine: */
-int sysctl_string(ctl_table *table, int __user *name, int nlen,
+int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
@@ -2391,7 +2391,7 @@ int sysctl_string(ctl_table *table, int __user *name, int nlen,
  * are between the minimum and maximum values given in the arrays
  * table->extra1 and table->extra2, respectively.
  */
-int sysctl_intvec(ctl_table *table, int __user *name, int nlen,
+int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2427,7 +2427,7 @@ int sysctl_intvec(ctl_table *table, int __user *name, int nlen,
 }
 
 /* Strategy function to convert jiffies to seconds */ 
-int sysctl_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2461,7 +2461,7 @@ int sysctl_jiffies(ctl_table *table, int __user *name, int nlen,
 }
 
 /* Strategy function to convert jiffies to seconds */ 
-int sysctl_ms_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2532,28 +2532,28 @@ out:
 	return -ENOSYS;
 }
 
-int sysctl_string(ctl_table *table, int __user *name, int nlen,
+int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_intvec(ctl_table *table, int __user *name, int nlen,
+int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_ms_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
-- 
1.5.1.1.181.g2de0




