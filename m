Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZLAE0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZLAE0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZLAE0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:26:41 -0500
Received: from ozlabs.org ([203.10.76.45]:35130 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZLAE0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:26:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] param: don't complain about unused module parameters.
Date: Tue, 1 Dec 2009 14:56:44 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Adam Williamson <awilliam@redhat.com>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011456.44457.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon confirms that recent modprobe will look in /proc/cmdline, so these
cmdline options can still be used.

See http://bugzilla.kernel.org/show_bug.cgi?id=14164

Reported-by: Adam Williamson <awilliam@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 init/main.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -251,7 +251,7 @@ early_param("loglevel", loglevel);
 
 /*
  * Unknown boot options get handed to init, unless they look like
- * failed parameters
+ * unused parameters (modprobe will find them in /proc/cmdline).
  */
 static int __init unknown_bootoption(char *param, char *val)
 {
@@ -272,14 +272,9 @@ static int __init unknown_bootoption(cha
 	if (obsolete_checksetup(param))
 		return 0;
 
-	/*
-	 * Preemptive maintenance for "why didn't my misspelled command
-	 * line work?"
-	 */
-	if (strchr(param, '.') && (!val || strchr(param, '.') < val)) {
-		printk(KERN_ERR "Unknown boot option `%s': ignoring\n", param);
+	/* Unused module parameter. */
+	if (strchr(param, '.') && (!val || strchr(param, '.') < val))
 		return 0;
-	}
 
 	if (panic_later)
 		return 0;
