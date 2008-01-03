Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYACXPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYACXPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYACXO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:14:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYACXO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:14:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=muXiqdfCAOOUtgosDbGRLFR6IZrb3u3EePXgLY6IrJMYlUpgPFu5hgKPPm5N8lT2RrKm0C/6HUCUN6IQphnPsDqW6bWc5N90zzB4PKp/QMVNI/TQGkJBRFrg4vmInbyMnhDFdZ7kg5cIEuJ04EZ2ZQhQZ434d3VeadVS/fwr4PY=
Date: Fri, 4 Jan 2008 00:14:46 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: linux-kernel@vger.kernel.org, bunk@kernel.org
Subject: [PATCH] This patch to printk.c fixes a few errors reported by
 checkpatch.pl
Message-ID: <20080104001446.66f0c110@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to printk.c fixes a few errors reported by checkpatch.pl

Before:
total: 18 errors, 17 warnings, 1306 lines checked

After:
total: 1 errors, 17 warnings, 1305 lines checked


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---

Adrian, I'm sending this patch to you because according to git shortlog -e
you are the most active modifier of this file.


 kernel/printk.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 89011bf..00f784f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -100,8 +100,7 @@ static unsigned long log_end;	/* Index into log_buf: most-recently-written-char
 /*
  *	Array of consoles built from command line options (console=)
  */
-struct console_cmdline
-{
+struct console_cmdline {
 	char	name[8];			/* Name of the driver	    */
 	int	index;				/* Minor dev. to use	    */
 	char	*options;			/* Options for the driver   */
@@ -323,7 +322,7 @@ int do_syslog(int type, char __user *buf, int len)
 			c = LOG_BUF(log_start);
 			log_start++;
 			spin_unlock_irq(&logbuf_lock);
-			error = __put_user(c,buf);
+			error = __put_user(c, buf);
 			buf++;
 			i++;
 			cond_resched();
@@ -368,7 +367,7 @@ int do_syslog(int type, char __user *buf, int len)
 				break;
 			c = LOG_BUF(j);
 			spin_unlock_irq(&logbuf_lock);
-			error = __put_user(c,&buf[count-1-i]);
+			error = __put_user(c, &buf[count-1-i]);
 			cond_resched();
 			spin_lock_irq(&logbuf_lock);
 		}
@@ -380,8 +379,8 @@ int do_syslog(int type, char __user *buf, int len)
 			int offset = count-error;
 			/* buffer overflow during copy, correct user buffer. */
 			for (i = 0; i < error; i++) {
-				if (__get_user(c,&buf[i+offset]) ||
-				    __put_user(c,&buf[i])) {
+				if (__get_user(c, &buf[i+offset]) ||
+				    __put_user(c, &buf[i])) {
 					error = -EFAULT;
 					break;
 				}
@@ -556,7 +555,7 @@ static void zap_locks(void)
 #if defined(CONFIG_PRINTK_TIME)
 static int printk_time = 1;
 #else
-static int printk_time = 0;
+static int printk_time ;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
@@ -659,7 +658,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	 */
 	for (p = printk_buf; *p; p++) {
 		if (log_level_unknown) {
-                        /* log_level_unknown signals the start of a new line */
+			/* log_level_unknown signals the start of a new line */
 			if (printk_time) {
 				int loglev_char;
 				char tbuf[50], *tp;
@@ -671,7 +670,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				 * force the log level token to be
 				 * before the time output.
 				 */
-				if (p[0] == '<' && p[1] >='0' &&
+				if (p[0] == '<' && p[1] >= '0' &&
 				   p[1] <= '7' && p[2] == '>') {
 					loglev_char = p[1];
 					p += 3;
@@ -1176,16 +1175,16 @@ EXPORT_SYMBOL(register_console);
 
 int unregister_console(struct console *console)
 {
-        struct console *a, *b;
+	struct console *a, *b;
 	int res = 1;
 
 	acquire_console_sem();
 	if (console_drivers == console) {
-		console_drivers=console->next;
+		console_drivers = console->next;
 		res = 0;
 	} else if (console_drivers) {
-		for (a=console_drivers->next, b=console_drivers ;
-		     a; b=a, a=b->next) {
+		for (a = console_drivers->next, b = console_drivers ;
+		     a; b = a, a = b->next) {
 			if (a == console) {
 				b->next = a->next;
 				res = 0;
-- 
1.5.4.rc2.17.g257f

