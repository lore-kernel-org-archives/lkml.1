Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZGDKIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZGDKIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZGDKI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:08:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:47443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbZGDKIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:08:25 -0400
Date: Sat, 4 Jul 2009 10:07:39 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703164225.GA21447@elte.hu>
Subject: [tip:x86/cleanups] x86: Clean up mtrr/if.c
Message-ID: <tip-26dc67eda19beafb7e5ef2770cec5b3ee5995a8e@git.kernel.org>
Git-Commit-ID: 26dc67eda19beafb7e5ef2770cec5b3ee5995a8e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:07:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26dc67eda19beafb7e5ef2770cec5b3ee5995a8e
Gitweb:     http://git.kernel.org/tip/26dc67eda19beafb7e5ef2770cec5b3ee5995a8e
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:53:40 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:19:48 +0200

x86: Clean up mtrr/if.c

Fix:

  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
  ERROR: trailing whitespace X 7
  ERROR: trailing statements should be on next line X 3
  WARNING: line over 80 characters X 5
  ERROR: space required before the open parenthesis '('

arch/x86/kernel/cpu/mtrr/if.o:

   text	   data	    bss	    dec	    hex	filename
   2239	      4	      0	   2243	    8c3	if.o.before
   2239	      4	      0	   2243	    8c3	if.o.after

md5:
   78d1f2aa4843ec6509c18e2dee54bc7f  if.o.before.asm
   78d1f2aa4843ec6509c18e2dee54bc7f  if.o.after.asm

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ More cleanups to make the code more consistent. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/if.c |  135 +++++++++++++++++++++++------------------
 1 files changed, 76 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index fb73a52..08b6ea4 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -1,27 +1,28 @@
-#include <linux/init.h>
-#include <linux/proc_fs.h>
 #include <linux/capability.h>
-#include <linux/ctype.h>
-#include <linux/module.h>
 #include <linux/seq_file.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
 
 #define LINE_SIZE 80
 
 #include <asm/mtrr.h>
+
 #include "mtrr.h"
 
 #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
 
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
 {
-    "uncachable",               /* 0 */
-    "write-combining",          /* 1 */
-    "?",                        /* 2 */
-    "?",                        /* 3 */
-    "write-through",            /* 4 */
-    "write-protect",            /* 5 */
-    "write-back",               /* 6 */
+	"uncachable",		/* 0 */
+	"write-combining",	/* 1 */
+	"?",			/* 2 */
+	"?",			/* 3 */
+	"write-through",	/* 4 */
+	"write-protect",	/* 5 */
+	"write-back",		/* 6 */
 };
 
 const char *mtrr_attrib_to_str(int x)
@@ -35,8 +36,8 @@ static int
 mtrr_file_add(unsigned long base, unsigned long size,
 	      unsigned int type, bool increment, struct file *file, int page)
 {
+	unsigned int *fcount = FILE_FCOUNT(file);
 	int reg, max;
-	unsigned int *fcount = FILE_FCOUNT(file); 
 
 	max = num_var_ranges;
 	if (fcount == NULL) {
@@ -61,8 +62,8 @@ static int
 mtrr_file_del(unsigned long base, unsigned long size,
 	      struct file *file, int page)
 {
-	int reg;
 	unsigned int *fcount = FILE_FCOUNT(file);
+	int reg;
 
 	if (!page) {
 		if ((base & (PAGE_SIZE - 1)) || (size & (PAGE_SIZE - 1)))
@@ -81,13 +82,14 @@ mtrr_file_del(unsigned long base, unsigned long size,
 	return reg;
 }
 
-/* RED-PEN: seq_file can seek now. this is ignored. */
+/*
+ * seq_file can seek but we ignore it.
+ *
+ * Format of control line:
+ *    "base=%Lx size=%Lx type=%s" or "disable=%d"
+ */
 static ssize_t
 mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
-/*  Format of control line:
-    "base=%Lx size=%Lx type=%s"     OR:
-    "disable=%d"
-*/
 {
 	int i, err;
 	unsigned long reg;
@@ -100,15 +102,18 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EPERM;
 	if (!len)
 		return -EINVAL;
+
 	memset(line, 0, LINE_SIZE);
 	if (len > LINE_SIZE)
 		len = LINE_SIZE;
 	if (copy_from_user(line, buf, len - 1))
 		return -EFAULT;
+
 	linelen = strlen(line);
 	ptr = line + linelen - 1;
 	if (linelen && *ptr == '\n')
 		*ptr = '\0';
+
 	if (!strncmp(line, "disable=", 8)) {
 		reg = simple_strtoul(line + 8, &ptr, 0);
 		err = mtrr_del_page(reg, 0, 0);
@@ -116,28 +121,35 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 			return err;
 		return len;
 	}
+
 	if (strncmp(line, "base=", 5))
 		return -EINVAL;
+
 	base = simple_strtoull(line + 5, &ptr, 0);
-	for (; isspace(*ptr); ++ptr) ;
+	for (; isspace(*ptr); ++ptr)
+		;
+
 	if (strncmp(ptr, "size=", 5))
 		return -EINVAL;
+
 	size = simple_strtoull(ptr + 5, &ptr, 0);
 	if ((base & 0xfff) || (size & 0xfff))
 		return -EINVAL;
-	for (; isspace(*ptr); ++ptr) ;
+	for (; isspace(*ptr); ++ptr)
+		;
+
 	if (strncmp(ptr, "type=", 5))
 		return -EINVAL;
 	ptr += 5;
-	for (; isspace(*ptr); ++ptr) ;
+	for (; isspace(*ptr); ++ptr)
+		;
+
 	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
 			continue;
 		base >>= PAGE_SHIFT;
 		size >>= PAGE_SHIFT;
-		err =
-		    mtrr_add_page((unsigned long) base, (unsigned long) size, i,
-				  true);
+		err = mtrr_add_page((unsigned long)base, (unsigned long)size, i, true);
 		if (err < 0)
 			return err;
 		return len;
@@ -181,7 +193,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	case MTRRIOC32_SET_PAGE_ENTRY:
 	case MTRRIOC32_DEL_PAGE_ENTRY:
 	case MTRRIOC32_KILL_PAGE_ENTRY: {
-		struct mtrr_sentry32 __user *s32 = (struct mtrr_sentry32 __user *)__arg;
+		struct mtrr_sentry32 __user *s32;
+
+		s32 = (struct mtrr_sentry32 __user *)__arg;
 		err = get_user(sentry.base, &s32->base);
 		err |= get_user(sentry.size, &s32->size);
 		err |= get_user(sentry.type, &s32->type);
@@ -191,7 +205,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	}
 	case MTRRIOC32_GET_ENTRY:
 	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
+		struct mtrr_gentry32 __user *g32;
+
+		g32 = (struct mtrr_gentry32 __user *)__arg;
 		err = get_user(gentry.regnum, &g32->regnum);
 		err |= get_user(gentry.base, &g32->base);
 		err |= get_user(gentry.size, &g32->size);
@@ -314,7 +330,7 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	if (err)
 		return err;
 
-	switch(cmd) {
+	switch (cmd) {
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
 		if (copy_to_user(arg, &gentry, sizeof gentry))
@@ -323,7 +339,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 #ifdef CONFIG_COMPAT
 	case MTRRIOC32_GET_ENTRY:
 	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
+		struct mtrr_gentry32 __user *g32;
+
+		g32 = (struct mtrr_gentry32 __user *)__arg;
 		err = put_user(gentry.base, &g32->base);
 		err |= put_user(gentry.size, &g32->size);
 		err |= put_user(gentry.regnum, &g32->regnum);
@@ -335,11 +353,10 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	return err;
 }
 
-static int
-mtrr_close(struct inode *ino, struct file *file)
+static int mtrr_close(struct inode *ino, struct file *file)
 {
-	int i, max;
 	unsigned int *fcount = FILE_FCOUNT(file);
+	int i, max;
 
 	if (fcount != NULL) {
 		max = num_var_ranges;
@@ -359,22 +376,22 @@ static int mtrr_seq_show(struct seq_file *seq, void *offset);
 
 static int mtrr_open(struct inode *inode, struct file *file)
 {
-	if (!mtrr_if) 
+	if (!mtrr_if)
 		return -EIO;
-	if (!mtrr_if->get) 
-		return -ENXIO; 
+	if (!mtrr_if->get)
+		return -ENXIO;
 	return single_open(file, mtrr_seq_show, NULL);
 }
 
 static const struct file_operations mtrr_fops = {
-	.owner   = THIS_MODULE,
-	.open	 = mtrr_open, 
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.write   = mtrr_write,
-	.unlocked_ioctl = mtrr_ioctl,
-	.compat_ioctl = mtrr_ioctl,
-	.release = mtrr_close,
+	.owner			= THIS_MODULE,
+	.open			= mtrr_open,
+	.read			= seq_read,
+	.llseek			= seq_lseek,
+	.write			= mtrr_write,
+	.unlocked_ioctl		= mtrr_ioctl,
+	.compat_ioctl		= mtrr_ioctl,
+	.release		= mtrr_close,
 };
 
 static int mtrr_seq_show(struct seq_file *seq, void *offset)
@@ -388,23 +405,24 @@ static int mtrr_seq_show(struct seq_file *seq, void *offset)
 	max = num_var_ranges;
 	for (i = 0; i < max; i++) {
 		mtrr_if->get(i, &base, &size, &type);
-		if (size == 0)
+		if (size == 0) {
 			mtrr_usage_table[i] = 0;
-		else {
-			if (size < (0x100000 >> PAGE_SHIFT)) {
-				/* less than 1MB */
-				factor = 'K';
-				size <<= PAGE_SHIFT - 10;
-			} else {
-				factor = 'M';
-				size >>= 20 - PAGE_SHIFT;
-			}
-			/* RED-PEN: base can be > 32bit */ 
-			len += seq_printf(seq, 
-				   "reg%02i: base=0x%06lx000 (%5luMB), size=%5lu%cB, count=%d: %s\n",
-			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_usage_table[i], mtrr_attrib_to_str(type));
+			continue;
 		}
+		if (size < (0x100000 >> PAGE_SHIFT)) {
+			/* less than 1MB */
+			factor = 'K';
+			size <<= PAGE_SHIFT - 10;
+		} else {
+			factor = 'M';
+			size >>= 20 - PAGE_SHIFT;
+		}
+		/* Base can be > 32bit */
+		len += seq_printf(seq, "reg%02i: base=0x%06lx000 "
+			"(%5luMB), size=%5lu%cB, count=%d: %s\n",
+			i, base, base >> (20 - PAGE_SHIFT), size,
+			factor, mtrr_usage_table[i],
+			mtrr_attrib_to_str(type));
 	}
 	return 0;
 }
@@ -422,6 +440,5 @@ static int __init mtrr_if_init(void)
 	proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_fops);
 	return 0;
 }
-
 arch_initcall(mtrr_if_init);
 #endif			/*  CONFIG_PROC_FS  */
