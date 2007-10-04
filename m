Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbXJDJ4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbXJDJ4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbXJDJ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:56:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37050 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754606AbXJDJ4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:56:38 -0400
Date: Thu, 4 Oct 2007 11:54:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: lp_console: cleanups
Message-ID: <20071004095454.GA838@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NULL initializers and clean whitespace a bit.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 62051f8..8267ff8 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -144,7 +144,7 @@ static unsigned int lp_count = 0;
 static struct class *lp_class;
 
 #ifdef CONFIG_LP_CONSOLE
-static struct parport *console_registered; // initially NULL
+static struct parport *console_registered;
 #endif /* CONFIG_LP_CONSOLE */
 
 #undef LP_DEBUG
@@ -749,8 +749,8 @@ #endif /* console on line printer */
 /* --- initialisation code ------------------------------------- */
 
 static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
-static char *parport[LP_NO] = { NULL,  };
-static int reset = 0;
+static char *parport[LP_NO];
+static int reset;
 
 module_param_array(parport, charp, NULL, 0);
 module_param(reset, bool, 0);
@@ -758,10 +758,10 @@ module_param(reset, bool, 0);
 #ifndef MODULE
 static int __init lp_setup (char *str)
 {
-	static int parport_ptr; // initially zero
+	static int parport_ptr;
 	int x;
 
-	if (get_option (&str, &x)) {
+	if (get_option(&str, &x)) {
 		if (x == 0) {
 			/* disable driver on "lp=" or "lp=0" */
 			parport_nr[0] = LP_PARPORT_OFF;
@@ -808,7 +808,7 @@ static int lp_register(int nr, struct pa
 #ifdef CONFIG_LP_CONSOLE
 	if (!nr) {
 		if (port->modes & PARPORT_MODE_SAFEININT) {
-			register_console (&lpcons);
+			register_console(&lpcons);
 			console_registered = port;
 			printk (KERN_INFO "lp%d: console ready\n", CONSOLE_LP);
 		} else
@@ -824,8 +824,7 @@ static void lp_attach (struct parport *p
 {
 	unsigned int i;
 
-	switch (parport_nr[0])
-	{
+	switch (parport_nr[0]) {
 	case LP_PARPORT_UNSPEC:
 	case LP_PARPORT_AUTO:
 		if (parport_nr[0] == LP_PARPORT_AUTO &&
@@ -856,7 +855,7 @@ static void lp_detach (struct parport *p
 	/* Write this some day. */
 #ifdef CONFIG_LP_CONSOLE
 	if (console_registered == port) {
-		unregister_console (&lpcons);
+		unregister_console(&lpcons);
 		console_registered = NULL;
 	}
 #endif /* CONFIG_LP_CONSOLE */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
