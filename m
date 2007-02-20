Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXBTACM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXBTACM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965576AbXBTACM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:02:12 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35986 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965573AbXBTACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:02:08 -0500
Date: Tue, 20 Feb 2007 01:02:07 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/char/hvc_console.c: cleanups
Message-ID: <20070220000207.GX13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make needlessly global code static
- remove the unused EXPORT_SYMBOL's

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/char/hvc_console.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.20-mm1/drivers/char/hvc_console.c.old	2007-02-16 14:34:20.000000000 +0100
+++ linux-2.6.20-mm1/drivers/char/hvc_console.c	2007-02-16 14:38:33.000000000 +0100
@@ -117,7 +117,7 @@
  * lock held.  If successful, this function increments the kobject reference
  * count against the target hvc_struct so it should be released when finished.
  */
-struct hvc_struct *hvc_get_by_index(int index)
+static struct hvc_struct *hvc_get_by_index(int index)
 {
 	struct hvc_struct *hp;
 	unsigned long flags;
@@ -156,7 +156,8 @@
  * hvc_console_setup() finds adapters.
  */
 
-void hvc_console_print(struct console *co, const char *b, unsigned count)
+static void hvc_console_print(struct console *co, const char *b,
+			      unsigned count)
 {
 	char c[N_OUTBUF] __ALIGNED__;
 	unsigned i = 0, n = 0;
@@ -214,7 +215,7 @@
 	return 0;
 }
 
-struct console hvc_con_driver = {
+static struct console hvc_con_driver = {
 	.name		= "hvc",
 	.write		= hvc_console_print,
 	.device		= hvc_console_device,
@@ -284,7 +285,6 @@
 
 	return 0;
 }
-EXPORT_SYMBOL(hvc_instantiate);
 
 /* Wake the sleeping khvcd */
 static void hvc_kick(void)
@@ -777,7 +777,6 @@
 
 	return hp;
 }
-EXPORT_SYMBOL(hvc_alloc);
 
 int __devexit hvc_remove(struct hvc_struct *hp)
 {
@@ -813,11 +812,10 @@
 		tty_hangup(tty);
 	return 0;
 }
-EXPORT_SYMBOL(hvc_remove);
 
 /* Driver initialization.  Follow console initialization.  This is where the TTY
  * interfaces start to become available. */
-int __init hvc_init(void)
+static int __init hvc_init(void)
 {
 	struct tty_driver *drv;
 

