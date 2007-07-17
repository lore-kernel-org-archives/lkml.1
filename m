Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbXGQOLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbXGQOLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbXGQOIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35935 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761134AbXGQOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:51 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 14/33] kbuild: .paravirtprobe section is obsolete, so modpost doesn't need to handle it
Date: Tue, 17 Jul 2007 16:08:43 +0200
Message-Id: <11846813441521-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813432234-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>

The .paravirtprobe section is obsolete, so modpost doesn't need to handle it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index fa33a6b..ece09c5 100644
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
1.5.0.6

