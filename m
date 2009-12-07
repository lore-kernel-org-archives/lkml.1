Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZLGAUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZLGAUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZLGAUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:20:39 -0500
Received: from kroah.org ([198.145.64.141]:34691 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499AbZLGANt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:57 2009
Message-Id: <20091207000657.204461287@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [093/119] param: dont complain about unused module parameters.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=param-don-t-complain-about-unused-module-parameters.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rusty Russell <rusty@rustcorp.com.au>

commit f066a4f6df68f03b565dfe867dde54dfeb26576e upstream.

Jon confirms that recent modprobe will look in /proc/cmdline, so these
cmdline options can still be used.

See http://bugzilla.kernel.org/show_bug.cgi?id=14164

Reported-by: Adam Williamson <awilliam@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/main.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -250,7 +250,7 @@ early_param("loglevel", loglevel);
 
 /*
  * Unknown boot options get handed to init, unless they look like
- * failed parameters
+ * unused parameters (modprobe will find them in /proc/cmdline).
  */
 static int __init unknown_bootoption(char *param, char *val)
 {
@@ -271,14 +271,9 @@ static int __init unknown_bootoption(cha
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


