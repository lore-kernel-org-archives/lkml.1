Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZFEXp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZFEXp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbZFEXln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:43 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36411 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbZFEXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:14 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Manish Katiyar <mkatiyar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 33/39] kernel/kallsyms.c: replace deprecated __initcall with device_initcall and fix whitespace
Date: Sat,  6 Jun 2009 01:42:51 +0200
Message-Id: <1244245377-17441-33-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manish Katiyar <mkatiyar@gmail.com>

Fix coding style whitespace issues and replace __initcall with
device_initcall.  Fixed multi-line comments as per coding style.

Errors as reported by checkpatch.pl :-
Before:
total: 14 errors, 14 warnings, 487 lines checked
After :
total: 0 errors, 8 warnings, 507 lines checked

Compile tested binary verified as :-
Before:
 text    data     bss     dec     hex filename
 2405       4       0    2409     969 kernel/kallsyms.o
After :
 text     data     bss     dec     hex filename
 2405       4       0    2409     969 kernel/kallsyms.o

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 kernel/kallsyms.c |  134 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 78 insertions(+), 56 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 374faf9..3a29dbe 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -30,12 +30,16 @@
 #define all_var 0
 #endif
 
-/* These will be re-linked against their real values during the second link stage */
+/*
+ * These will be re-linked against their real values
+ * during the second link stage.
+ */
 extern const unsigned long kallsyms_addresses[] __attribute__((weak));
 extern const u8 kallsyms_names[] __attribute__((weak));
 
-/* tell the compiler that the count isn't in the small data section if the arch
- * has one (eg: FRV)
+/*
+ * Tell the compiler that the count isn't in the small data section if the arch
+ * has one (eg: FRV).
  */
 extern const unsigned long kallsyms_num_syms
 __attribute__((weak, section(".rodata")));
@@ -75,31 +79,37 @@ static int is_ksym_addr(unsigned long addr)
 	return is_kernel_text(addr) || is_kernel_inittext(addr);
 }
 
-/* expand a compressed symbol data into the resulting uncompressed string,
-   given the offset to where the symbol is in the compressed stream */
+/*
+ * Expand a compressed symbol data into the resulting uncompressed string,
+ * given the offset to where the symbol is in the compressed stream.
+ */
 static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
 {
 	int len, skipped_first = 0;
 	const u8 *tptr, *data;
 
-	/* get the compressed symbol length from the first symbol byte */
+	/* Get the compressed symbol length from the first symbol byte. */
 	data = &kallsyms_names[off];
 	len = *data;
 	data++;
 
-	/* update the offset to return the offset for the next symbol on
-	 * the compressed stream */
+	/*
+	 * Update the offset to return the offset for the next symbol on
+	 * the compressed stream.
+	 */
 	off += len + 1;
 
-	/* for every byte on the compressed symbol data, copy the table
-	   entry for that byte */
-	while(len) {
-		tptr = &kallsyms_token_table[ kallsyms_token_index[*data] ];
+	/*
+	 * For every byte on the compressed symbol data, copy the table
+	 * entry for that byte.
+	 */
+	while (len) {
+		tptr = &kallsyms_token_table[kallsyms_token_index[*data]];
 		data++;
 		len--;
 
 		while (*tptr) {
-			if(skipped_first) {
+			if (skipped_first) {
 				*result = *tptr;
 				result++;
 			} else
@@ -110,36 +120,46 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
 
 	*result = '\0';
 
-	/* return to offset to the next symbol */
+	/* Return to offset to the next symbol. */
 	return off;
 }
 
-/* get symbol type information. This is encoded as a single char at the
- * begining of the symbol name */
+/*
+ * Get symbol type information. This is encoded as a single char at the
+ * beginning of the symbol name.
+ */
 static char kallsyms_get_symbol_type(unsigned int off)
 {
-	/* get just the first code, look it up in the token table, and return the
-	 * first char from this token */
-	return kallsyms_token_table[ kallsyms_token_index[ kallsyms_names[off+1] ] ];
+	/*
+	 * Get just the first code, look it up in the token table,
+	 * and return the first char from this token.
+	 */
+	return kallsyms_token_table[kallsyms_token_index[kallsyms_names[off + 1]]];
 }
 
 
-/* find the offset on the compressed stream given and index in the
- * kallsyms array */
+/*
+ * Find the offset on the compressed stream given and index in the
+ * kallsyms array.
+ */
 static unsigned int get_symbol_offset(unsigned long pos)
 {
 	const u8 *name;
 	int i;
 
-	/* use the closest marker we have. We have markers every 256 positions,
-	 * so that should be close enough */
-	name = &kallsyms_names[ kallsyms_markers[pos>>8] ];
+	/*
+	 * Use the closest marker we have. We have markers every 256 positions,
+	 * so that should be close enough.
+	 */
+	name = &kallsyms_names[kallsyms_markers[pos >> 8]];
 
-	/* sequentially scan all the symbols up to the point we're searching for.
-	 * Every symbol is stored in a [<len>][<len> bytes of data] format, so we
-	 * just need to add the len to the current pointer for every symbol we
-	 * wish to skip */
-	for(i = 0; i < (pos&0xFF); i++)
+	/*
+	 * Sequentially scan all the symbols up to the point we're searching
+	 * for. Every symbol is stored in a [<len>][<len> bytes of data] format,
+	 * so we just need to add the len to the current pointer for every
+	 * symbol we wish to skip.
+	 */
+	for (i = 0; i < (pos & 0xFF); i++)
 		name = name + (*name) + 1;
 
 	return name - kallsyms_names;
@@ -190,7 +210,7 @@ static unsigned long get_symbol_pos(unsigned long addr,
 	/* This kernel should never had been booted. */
 	BUG_ON(!kallsyms_addresses);
 
-	/* do a binary search on the sorted kallsyms_addresses array */
+	/* Do a binary search on the sorted kallsyms_addresses array. */
 	low = 0;
 	high = kallsyms_num_syms;
 
@@ -203,15 +223,15 @@ static unsigned long get_symbol_pos(unsigned long addr,
 	}
 
 	/*
-	 * search for the first aliased symbol. Aliased
-	 * symbols are symbols with the same address
+	 * Search for the first aliased symbol. Aliased
+	 * symbols are symbols with the same address.
 	 */
 	while (low && kallsyms_addresses[low-1] == kallsyms_addresses[low])
 		--low;
 
 	symbol_start = kallsyms_addresses[low];
 
-	/* Search for next non-aliased symbol */
+	/* Search for next non-aliased symbol. */
 	for (i = low + 1; i < kallsyms_num_syms; i++) {
 		if (kallsyms_addresses[i] > symbol_start) {
 			symbol_end = kallsyms_addresses[i];
@@ -219,7 +239,7 @@ static unsigned long get_symbol_pos(unsigned long addr,
 		}
 	}
 
-	/* if we found no next symbol, we use the end of the section */
+	/* If we found no next symbol, we use the end of the section. */
 	if (!symbol_end) {
 		if (is_kernel_inittext(addr))
 			symbol_end = (unsigned long)_einittext;
@@ -252,10 +272,10 @@ int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 
 /*
  * Lookup an address
- * - modname is set to NULL if it's in the kernel
- * - we guarantee that the returned name is valid until we reschedule even if
- *   it resides in a module
- * - we also guarantee that modname will be valid until rescheduled
+ * - modname is set to NULL if it's in the kernel.
+ * - We guarantee that the returned name is valid until we reschedule even if.
+ *   It resides in a module.
+ * - We also guarantee that modname will be valid until rescheduled.
  */
 const char *kallsyms_lookup(unsigned long addr,
 			    unsigned long *symbolsize,
@@ -276,7 +296,7 @@ const char *kallsyms_lookup(unsigned long addr,
 		return namebuf;
 	}
 
-	/* see if it's in a module */
+	/* See if it's in a module. */
 	return module_address_lookup(addr, symbolsize, offset, modname,
 				     namebuf);
 }
@@ -294,7 +314,7 @@ int lookup_symbol_name(unsigned long addr, char *symname)
 		kallsyms_expand_symbol(get_symbol_offset(pos), symname);
 		return 0;
 	}
-	/* see if it's in a module */
+	/* See if it's in a module. */
 	return lookup_module_symbol_name(addr, symname);
 }
 
@@ -313,7 +333,7 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
 		modname[0] = '\0';
 		return 0;
 	}
-	/* see if it's in a module */
+	/* See if it's in a module. */
 	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
 }
 
@@ -342,6 +362,7 @@ int sprint_symbol(char *buffer, unsigned long address)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(sprint_symbol);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
@@ -352,13 +373,13 @@ void __print_symbol(const char *fmt, unsigned long address)
 
 	printk(fmt, buffer);
 }
+EXPORT_SYMBOL(__print_symbol);
 
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
-struct kallsym_iter
-{
+struct kallsym_iter {
 	loff_t pos;
 	unsigned long value;
-	unsigned int nameoff; /* If iterating in core kernel symbols */
+	unsigned int nameoff; /* If iterating in core kernel symbols. */
 	char type;
 	char name[KSYM_NAME_LEN];
 	char module_name[MODULE_NAME_LEN];
@@ -404,7 +425,7 @@ static int update_iter(struct kallsym_iter *iter, loff_t pos)
 		iter->pos = pos;
 		return get_ksymbol_mod(iter);
 	}
-	
+
 	/* If we're not on the desired position, reset to new position. */
 	if (pos != iter->pos)
 		reset_iter(iter, pos);
@@ -439,23 +460,25 @@ static int s_show(struct seq_file *m, void *p)
 {
 	struct kallsym_iter *iter = m->private;
 
-	/* Some debugging symbols have no name.  Ignore them. */ 
+	/* Some debugging symbols have no name.  Ignore them. */
 	if (!iter->name[0])
 		return 0;
 
 	if (iter->module_name[0]) {
 		char type;
 
-		/* Label it "global" if it is exported,
-		 * "local" if not exported. */
+		/*
+		 * Label it "global" if it is exported,
+		 * "local" if not exported.
+		 */
 		type = iter->exported ? toupper(iter->type) :
 					tolower(iter->type);
 		seq_printf(m, "%0*lx %c %s\t[%s]\n",
-			   (int)(2*sizeof(void*)),
+			   (int)(2 * sizeof(void *)),
 			   iter->value, type, iter->name, iter->module_name);
 	} else
 		seq_printf(m, "%0*lx %c %s\n",
-			   (int)(2*sizeof(void*)),
+			   (int)(2 * sizeof(void *)),
 			   iter->value, iter->type, iter->name);
 	return 0;
 }
@@ -469,9 +492,11 @@ static const struct seq_operations kallsyms_op = {
 
 static int kallsyms_open(struct inode *inode, struct file *file)
 {
-	/* We keep iterator in m->private, since normal case is to
+	/*
+	 * We keep iterator in m->private, since normal case is to
 	 * s_start from where we left off, so we avoid doing
-	 * using get_symbol_offset for every symbol */
+	 * using get_symbol_offset for every symbol.
+	 */
 	struct kallsym_iter *iter;
 	int ret;
 
@@ -500,7 +525,4 @@ static int __init kallsyms_init(void)
 	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
 	return 0;
 }
-__initcall(kallsyms_init);
-
-EXPORT_SYMBOL(__print_symbol);
-EXPORT_SYMBOL_GPL(sprint_symbol);
+device_initcall(kallsyms_init);
-- 
1.6.3.rc3.40.g75b44

