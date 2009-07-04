Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZGDCcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZGDCcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbZGDCcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:32:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:47362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759426AbZGDCcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:32:15 -0400
Subject: [PATCH 6/9 -tip] x86: mtrr/if.c fix trivial style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674180.2642.10.camel@ht.satnam>
References: <20090703095432.GC21141@elte.hu>
	 <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	 <20090703102234.GA32128@elte.hu>
	 <20090703114431.37abd528@lxorguk.ukuu.org.uk>
	 <20090703131727.GA3207@elte.hu>
	 <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	 <20090703144754.GA13246@elte.hu>
	 <20090703160230.093e422c@lxorguk.ukuu.org.uk>
	 <20090703155809.GA20121@elte.hu>
	 <20090703172651.619162fd@lxorguk.ukuu.org.uk>
	 <20090703164225.GA21447@elte.hu>  <1246673939.2642.5.camel@ht.satnam>
	 <1246674000.2642.6.camel@ht.satnam>  <1246674044.2642.7.camel@ht.satnam>
	 <1246674092.2642.8.camel@ht.satnam>  <1246674128.2642.9.camel@ht.satnam>
	 <1246674180.2642.10.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:53:40 +0530
Message-Id: <1246674220.2642.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix :

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ERROR: trailing whitespace X 7
ERROR: trailing statements should be on next line X 3
WARNING: line over 80 characters X 5
ERROR: space required before the open parenthesis '('

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/if.c |   51 ++++++++++++++++++++++++++--------------
 1 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index fb73a52..74a7e54 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -4,7 +4,7 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define LINE_SIZE 80
 
@@ -36,7 +36,7 @@ mtrr_file_add(unsigned long base, unsigned long size,
 	      unsigned int type, bool increment, struct file *file, int page)
 {
 	int reg, max;
-	unsigned int *fcount = FILE_FCOUNT(file); 
+	unsigned int *fcount = FILE_FCOUNT(file);
 
 	max = num_var_ranges;
 	if (fcount == NULL) {
@@ -109,6 +109,7 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	ptr = line + linelen - 1;
 	if (linelen && *ptr == '\n')
 		*ptr = '\0';
+
 	if (!strncmp(line, "disable=", 8)) {
 		reg = simple_strtoul(line + 8, &ptr, 0);
 		err = mtrr_del_page(reg, 0, 0);
@@ -116,20 +117,27 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 			return err;
 		return len;
 	}
+
 	if (strncmp(line, "base=", 5))
 		return -EINVAL;
 	base = simple_strtoull(line + 5, &ptr, 0);
-	for (; isspace(*ptr); ++ptr) ;
+	for (; isspace(*ptr); ++ptr)
+		;
+
 	if (strncmp(ptr, "size=", 5))
 		return -EINVAL;
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
@@ -181,7 +189,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
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
@@ -191,7 +201,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
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
@@ -314,7 +326,7 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	if (err)
 		return err;
 
-	switch(cmd) {
+	switch (cmd) {
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
 		if (copy_to_user(arg, &gentry, sizeof gentry))
@@ -323,7 +335,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 #ifdef CONFIG_COMPAT
 	case MTRRIOC32_GET_ENTRY:
 	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
+		struct mtrr_gentry32 __user *g32
+
+		g32 = (struct mtrr_gentry32 __user *)__arg;
 		err = put_user(gentry.base, &g32->base);
 		err |= put_user(gentry.size, &g32->size);
 		err |= put_user(gentry.regnum, &g32->regnum);
@@ -359,16 +373,16 @@ static int mtrr_seq_show(struct seq_file *seq, void *offset);
 
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
 	.owner   = THIS_MODULE,
-	.open	 = mtrr_open, 
+	.open	 = mtrr_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.write   = mtrr_write,
@@ -399,11 +413,12 @@ static int mtrr_seq_show(struct seq_file *seq, void *offset)
 				factor = 'M';
 				size >>= 20 - PAGE_SHIFT;
 			}
-			/* RED-PEN: base can be > 32bit */ 
-			len += seq_printf(seq, 
-				   "reg%02i: base=0x%06lx000 (%5luMB), size=%5lu%cB, count=%d: %s\n",
-			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_usage_table[i], mtrr_attrib_to_str(type));
+			/* RED-PEN: base can be > 32bit */
+			len += seq_printf(seq, "reg%02i: base=0x%06lx000 "
+				"(%5luMB), size=%5lu%cB, count=%d: %s\n",
+				i, base, base >> (20 - PAGE_SHIFT), size,
+				factor, mtrr_usage_table[i],
+				mtrr_attrib_to_str(type));
 		}
 	}
 	return 0;
-- 
1.6.0.6



