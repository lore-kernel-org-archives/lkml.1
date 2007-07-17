Return-Path: <linux-kernel-owner+w=401wt.eu-S933956AbXGQORZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbXGQORZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763765AbXGQOIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:16 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35933 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760730AbXGQOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 23/33] modpost white list pattern adjustment
Date: Tue, 17 Jul 2007 16:08:52 +0200
Message-Id: <118468134441-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813442810-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

gcc puts data into .data.rel or .data.rel.* on some architectures (e.g.
ia64) or under certain conditions, so whatever is legal relative to
.data should also be legal for those other sections. Fixes a few
modpost warnings on ia64.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ec036c2..3f3848f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -609,7 +609,7 @@ static int strrcmp(const char *s, const char *sub)
  *   warn here.
  *   the pattern is identified by:
  *   tosec   = .init.text | .exit.text | .init.data
- *   fromsec = .data
+ *   fromsec = .data | .data.rel | .data.rel.*
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
  *
  * Pattern 3:
@@ -672,7 +672,9 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strcmp(tosec, ".exit.text") != 0) &&
 	    (strcmp(tosec, ".init.data") != 0))
 		f2 = 0;
-	if (strcmp(fromsec, ".data") != 0)
+	if ((strcmp(fromsec, ".data") != 0) &&
+	    (strcmp(fromsec, ".data.rel") != 0) &&
+	    (strncmp(fromsec, ".data.rel.", strlen(".data.rel.")) != 0))
 		f2 = 0;
 
 	for (s = pat2sym; *s; s++)
-- 
1.5.0.6

