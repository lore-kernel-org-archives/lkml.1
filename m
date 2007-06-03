Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXFCUsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXFCUsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbXFCUrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:47:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53164 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbXFCUrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:47:21 -0400
Date: Sun, 3 Jun 2007 22:48:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 12/19] kbuild: The .paravirtprobe section is obsolete, so modpost doesn't need to handle it
Message-ID: <20070603204822.GM9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 12/19] kbuild: The .paravirtprobe section is obsolete, so modpost doesn't need to handle it
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Tue, 29 May 2007 13:33:01 -0700

The .paravirtprobe section is obsolete, so modpost doesn't need to handle it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f6bae03..662deba 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -637,12 +637,6 @@ static int strrcmp(const char *s, const char *sub)
  *  fromsec    = .text*
  *  refsymname = logo_
  *
- * Pattern 8:
- *  Symbols contained in .paravirtprobe may safely reference .init.text.
- *  The pattern is:
- *  tosec   = .init.text
- *  fromsec  = .paravirtprobe
- *
  * Pattern 10:
  *  ia64 has machvec table for each platform and
  *  powerpc has a machine desc table for each platform.
@@ -726,11 +720,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
 		return 1;
 
-	/* Check for pattern 8 */
-	if ((strcmp(tosec, ".init.text") == 0) &&
-	    (strcmp(fromsec, ".paravirtprobe") == 0))
-		return 1;
-
 	/* Check for pattern 10 */
 	if ((strcmp(fromsec, ".machvec") == 0) ||
 	    (strcmp(fromsec, ".machine.desc") == 0))
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
