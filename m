Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbXEXEQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbXEXEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758517AbXEXEQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:16:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43974 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180AbXEXEQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:16:20 -0400
Date: Thu, 24 May 2007 14:16:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: paulus@samba.org, ppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] [POWERPC] suppress modpost warnings for references from the
 .toc
Message-Id: <20070524141613.4ba38e2f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We should do better here by effetively "dereferencing" references to
the .toc (or the .got2) section, but that is much harder.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/mod/modpost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8e5610d..fe5f89b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -865,9 +865,12 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
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
1.5.1.4

