Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZBPQY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZBPQY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZBPQYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:24:46 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:15942 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZBPQY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fcDPYWAoOZGFWVmKV3iAIodDAuqfZWKUJ7LaF4J0T8kHmU9sHFVVwAzD0w81ny7WBC
         kb+/TWR3LAwYngEuR3DWezKdnAfew4gHCjwzLP23vcLCYk6FiUIq5gZxNYKsRTuS6N3t
         WdPBMFAM787HiLVsSMEmoDV2lSmzjERT7x9vs=
MIME-Version: 1.0
Date: Mon, 16 Feb 2009 21:54:25 +0530
Message-ID: <ea11fea30902160824l22b10dcblc89c718015e156c8@mail.gmail.com>
Subject: [PATCH] Replace deprecated __initcall with device_initcall and fix 
	whitespaces in kernel/kallsyms.c
From: Manish Katiyar <mkatiyar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Cc: mkatiyar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to fix coding style whitespace issues and replace __initcall
with device_initcall

Errors as reported by checkpatch.pl :-
Before:
total: 14 errors, 14 warnings, 487 lines checked
After :
total: 0 errors, 11 warnings, 486 lines checked

Compile tested binary verified as :-
Before:
  text    data     bss     dec     hex filename
   2405       4       0    2409     969 kernel/kallsyms.o
After :
  text	   data	    bss	    dec	    hex	filename
   2405	      4	      0	   2409	    969	kernel/kallsyms.o


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 kernel/kallsyms.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 7b8b0f2..0e4eae6 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -93,13 +93,13 @@ static unsigned int
kallsyms_expand_symbol(unsigned int off, char *result)

 	/* for every byte on the compressed symbol data, copy the table
 	   entry for that byte */
-	while(len) {
-		tptr = &kallsyms_token_table[ kallsyms_token_index[*data] ];
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
@@ -120,7 +120,7 @@ static char kallsyms_get_symbol_type(unsigned int off)
 {
 	/* get just the first code, look it up in the token table, and return the
 	 * first char from this token */
-	return kallsyms_token_table[ kallsyms_token_index[ kallsyms_names[off+1] ] ];
+	return kallsyms_token_table[kallsyms_token_index[kallsyms_names[off + 1]]];
 }


@@ -133,13 +133,13 @@ static unsigned int get_symbol_offset(unsigned long pos)

 	/* use the closest marker we have. We have markers every 256 positions,
 	 * so that should be close enough */
-	name = &kallsyms_names[ kallsyms_markers[pos>>8] ];
+	name = &kallsyms_names[kallsyms_markers[pos >> 8]];

 	/* sequentially scan all the symbols up to the point we're searching for.
 	 * Every symbol is stored in a [<len>][<len> bytes of data] format, so we
 	 * just need to add the len to the current pointer for every symbol we
 	 * wish to skip */
-	for(i = 0; i < (pos&0xFF); i++)
+	for (i = 0; i < (pos&0xFF); i++)
 		name = name + (*name) + 1;

 	return name - kallsyms_names;
@@ -323,6 +323,7 @@ int sprint_symbol(char *buffer, unsigned long address)

 	return len;
 }
+EXPORT_SYMBOL_GPL(sprint_symbol);

 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
@@ -333,10 +334,10 @@ void __print_symbol(const char *fmt, unsigned
long address)

 	printk(fmt, buffer);
 }
+EXPORT_SYMBOL(__print_symbol);

 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
-struct kallsym_iter
-{
+struct kallsym_iter {
 	loff_t pos;
 	unsigned long value;
 	unsigned int nameoff; /* If iterating in core kernel symbols */
@@ -385,7 +386,7 @@ static int update_iter(struct kallsym_iter *iter,
loff_t pos)
 		iter->pos = pos;
 		return get_ksymbol_mod(iter);
 	}
-	
+
 	/* If we're not on the desired position, reset to new position. */
 	if (pos != iter->pos)
 		reset_iter(iter, pos);
@@ -420,7 +421,7 @@ static int s_show(struct seq_file *m, void *p)
 {
 	struct kallsym_iter *iter = m->private;

-	/* Some debugging symbols have no name.  Ignore them. */
+	/* Some debugging symbols have no name.  Ignore them. */
 	if (!iter->name[0])
 		return 0;

@@ -432,11 +433,11 @@ static int s_show(struct seq_file *m, void *p)
 		type = iter->exported ? toupper(iter->type) :
 					tolower(iter->type);
 		seq_printf(m, "%0*lx %c %s\t[%s]\n",
-			   (int)(2*sizeof(void*)),
+			   (int)(2*sizeof(void *)),
 			   iter->value, type, iter->name, iter->module_name);
 	} else
 		seq_printf(m, "%0*lx %c %s\n",
-			   (int)(2*sizeof(void*)),
+			   (int)(2*sizeof(void *)),
 			   iter->value, iter->type, iter->name);
 	return 0;
 }
@@ -481,7 +482,5 @@ static int __init kallsyms_init(void)
 	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
 	return 0;
 }
-__initcall(kallsyms_init);
+device_initcall(kallsyms_init);

-EXPORT_SYMBOL(__print_symbol);
-EXPORT_SYMBOL_GPL(sprint_symbol);
-- 
1.5.4.3


Thanks -
Manish
