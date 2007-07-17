Return-Path: <linux-kernel-owner+w=401wt.eu-S934130AbXGQOTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130AbXGQOTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763946AbXGQOIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35923 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761079AbXGQOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 13/33] kbuild: suppress modpost warnings for references from the .toc section as used by powerpc
Date: Tue, 17 Jul 2007 16:08:42 +0200
Message-Id: <11846813432234-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1184681343423-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

We should do better here by effetively "dereferencing" references to
the .toc (or the .got2) section, but that is much harder.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 256b3d2..fa33a6b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -870,9 +870,12 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 		return;
 
 	/* fromsec whitelist - without a valid 'before'
-	 * powerpc has a GOT table in .got2 section */
+	 * powerpc has a GOT table in .got2 section
+	 * and also a .toc section */
 	if (strcmp(fromsec, ".got2") == 0)
 		return;
+	if (strcmp(fromsec, ".toc") == 0)
+		return;
 
 	if (before && after) {
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
-- 
1.5.0.6

