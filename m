Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbYJIX4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbYJIX4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYJIXy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:54:59 -0400
Received: from xenotime.net ([66.160.160.81]:52323 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752765AbYJIXy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:54:57 -0400
Date: Thu, 09 Oct 2008 16:52:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] docs: add printk lib. extensions
Message-ID: <12235963551949@xenotime.net>
In-Reply-To: <12235963551043@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add documentation in kerneldoc for new printk format extensions

This patch documents the new %pS/%pF options in printk in kernel doc.

Hope I didn't miss any other extension.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 kernel/printk.c |    2 ++
 lib/vsprintf.c  |   12 ++++++++++++
 2 files changed, 14 insertions(+)

--- linux-2.6.27-rc9-git2.orig/kernel/printk.c
+++ linux-2.6.27-rc9-git2/kernel/printk.c
@@ -593,6 +593,8 @@ static int have_callable_console(void)
  *
  * See also:
  * printf(3)
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 
 asmlinkage int printk(const char *fmt, ...)
--- linux-2.6.27-rc9-git2.orig/lib/vsprintf.c
+++ linux-2.6.27-rc9-git2/lib/vsprintf.c
@@ -565,6 +565,10 @@ static char *pointer(const char *fmt, ch
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
+ * This function follows C99 vsnprintf, but has some extensions:
+ * %pS - output the name of a text symbol
+ * %pF - output the name of a function pointer
+ *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
  * '\0', as per ISO C99. If you want to have the exact
@@ -806,6 +810,8 @@ EXPORT_SYMBOL(vsnprintf);
  *
  * Call this function if you are already dealing with a va_list.
  * You probably want scnprintf() instead.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
@@ -828,6 +834,8 @@ EXPORT_SYMBOL(vscnprintf);
  * generated for the given input, excluding the trailing null,
  * as per ISO C99.  If the return is greater than or equal to
  * @size, the resulting string is truncated.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int snprintf(char * buf, size_t size, const char *fmt, ...)
 {
@@ -877,6 +885,8 @@ EXPORT_SYMBOL(scnprintf);
  *
  * Call this function if you are already dealing with a va_list.
  * You probably want sprintf() instead.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int vsprintf(char *buf, const char *fmt, va_list args)
 {
@@ -894,6 +904,8 @@ EXPORT_SYMBOL(vsprintf);
  * The function returns the number of characters written
  * into @buf. Use snprintf() or scnprintf() in order to avoid
  * buffer overflows.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int sprintf(char * buf, const char *fmt, ...)
 {


-- 

