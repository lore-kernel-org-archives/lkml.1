Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXFCUp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXFCUp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXFCUp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:45:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55861 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbXFCUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:45:24 -0400
Date: Sun, 3 Jun 2007 22:46:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 06/19] kbuild: suppress modpost warnings for references from the .toc section as used by powerpc
Message-ID: <20070603204626.GF9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 06/19] kbuild: suppress modpost warnings for references from the .toc section as used by powerpc
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 May 2007 14:16:13 +1000

We should do better here by effetively "dereferencing" references to
the .toc (or the .got2) section, but that is much harder.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 760b2b3..f6bae03 100644
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
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
