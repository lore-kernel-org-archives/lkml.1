Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbXLCXw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbXLCXw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXLCXwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:52:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXLCXwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:52:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Freezer: Fix JFFS2 garbage collector freezing issue (rev. 2)
Date: Tue, 4 Dec 2007 01:11:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Pete MacKay <armlinux@architechnical.net>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712040111.10494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is a replacement for
freezer-fix-jffs2-garbage-collector-freezing-issue.patch]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix breakage caused by commit d5d8c5976d6adeddb8208c240460411e2198b393
"freezer: do not send signals to kernel threads" in
jffs2_garbage_collect_thread() that assumed it would be sent signals
by the freezer.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Pete MacKay <armlinux@architechnical.net>
---
 fs/jffs2/background.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/jffs2/background.c
===================================================================
--- linux-2.6.orig/fs/jffs2/background.c
+++ linux-2.6/fs/jffs2/background.c
@@ -105,7 +105,7 @@ static int jffs2_garbage_collect_thread(
 
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
-		while (signal_pending(current)) {
+		while (signal_pending(current) || freezing(current)) {
 			siginfo_t info;
 			unsigned long signr;
 
