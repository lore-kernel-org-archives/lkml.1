Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYJGKPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYJGKPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYJGKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:15:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44130 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYJGKPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:15:35 -0400
Date: Tue, 7 Oct 2008 12:15:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] Add kerneldoc documentation for new printk format extensions
Message-ID: <20081007101532.GA25565@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation in kerneldoc for new printk format extensions

This patch documents the new %pS/%pF options in printk in kernel doc.

Hope I didn't miss any other extension.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc6-misc/kernel/printk.c
===================================================================
--- linux-2.6.27-rc6-misc.orig/kernel/printk.c
+++ linux-2.6.27-rc6-misc/kernel/printk.c
@@ -593,6 +593,8 @@ static int have_callable_console(void)
  *
  * See also:
  * printf(3)
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 
 asmlinkage int printk(const char *fmt, ...)
Index: linux-2.6.27-rc6-misc/lib/vsprintf.c
===================================================================
--- linux-2.6.27-rc6-misc.orig/lib/vsprintf.c
+++ linux-2.6.27-rc6-misc/lib/vsprintf.c
@@ -565,6 +565,10 @@ static char *pointer(const char *fmt, ch
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
+ * This function follows C99 vsnprintf, but has some extensions:
+ * %pS output the name of a text symbol
+ * %pF output the name of a function pointer
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
