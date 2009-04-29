Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbZD2TM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbZD2TM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZD2TMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:12:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:47327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZD2TMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:12:15 -0400
Date: Wed, 29 Apr 2009 19:09:32 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, torvalds@linux-foundation.org,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       akpm@linux-foundation.org, vapier@gentoo.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, torvalds@linux-foundation.org, lizf@cn.fujitsu.com,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, akpm@linux-foundation.org,
       rostedt@goodmis.org, vapier@gentoo.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090415154817.GC5989@nowhere>
References: <20090415154817.GC5989@nowhere>
Subject: [tip:core/printk] vsprintf: introduce %pf format specifier
Message-ID: <tip-0c8b946e3ebb3846103486420ea7430a4b5e5b1b@git.kernel.org>
Git-Commit-ID: 0c8b946e3ebb3846103486420ea7430a4b5e5b1b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 19:09:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c8b946e3ebb3846103486420ea7430a4b5e5b1b
Gitweb:     http://git.kernel.org/tip/0c8b946e3ebb3846103486420ea7430a4b5e5b1b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 15 Apr 2009 17:48:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 20:55:55 +0200

vsprintf: introduce %pf format specifier

A printf format specifier which would allow us to print a pure
function name has been suggested by Andrew Morton a couple of
months ago.

The current %pF is very convenient to print a function symbol,
but often we only want to print the name of the function, without
its asm offset.

That's what  %pf does in this patch.  The lowecase f has been chosen
for its intuitive meaning of a 'weak kind of %pF'.

The support for this new format would be welcome by the tracing code
where the need to print pure function names is often needed. This is
also true for other parts of the kernel:

$ git-grep -E "kallsyms_lookup\(.+?\)"
arch/blackfin/kernel/traps.c:   symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
arch/powerpc/xmon/xmon.c:               name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
arch/sh/kernel/cpu/sh5/unwind.c:        sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
arch/x86/kernel/ftrace.c:       kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
kernel/kprobes.c:               sym = kallsyms_lookup((unsigned long)p->addr, NULL,
kernel/lockdep.c:       return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
kernel/trace/ftrace.c:  kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
kernel/trace/trace_functions.c: kallsyms_lookup(ip, NULL, NULL, NULL, str);
kernel/trace/trace_output.c:    kallsyms_lookup(address, NULL, NULL, NULL, str);

Changes in v2:

- Add the explanation of the %pf role for vsnprintf() and bstr_printf()

- Change the comments by dropping the "asm offset" notion and only
  define the %pf against the actual function offset notion.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090415154817.GC5989@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/vsprintf.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b56f6d0..756ccaf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -575,12 +575,15 @@ static char *string(char *buf, char *end, char *s, struct printf_spec spec)
 }
 
 static char *symbol_string(char *buf, char *end, void *ptr,
-				struct printf_spec spec)
+				struct printf_spec spec, char ext)
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	sprint_symbol(sym, value);
+	if (ext != 'f')
+		sprint_symbol(sym, value);
+	else
+		kallsyms_lookup(value, NULL, NULL, NULL, sym);
 	return string(buf, end, sym, spec);
 #else
 	spec.field_width = 2*sizeof(void *);
@@ -692,7 +695,8 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr,
  *
  * Right now we handle:
  *
- * - 'F' For symbolic function descriptor pointers
+ * - 'F' For symbolic function descriptor pointers with offset
+ * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
@@ -715,10 +719,11 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 
 	switch (*fmt) {
 	case 'F':
+	case 'f':
 		ptr = dereference_function_descriptor(ptr);
 		/* Fallthrough */
 	case 'S':
-		return symbol_string(buf, end, ptr, spec);
+		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 		return resource_string(buf, end, ptr, spec);
 	case 'm':
@@ -954,7 +959,8 @@ qualifier:
  *
  * This function follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  *
  * The return value is the number of characters which would
@@ -1412,7 +1418,8 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  *
  * The format follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  * %n is ignored
  *
