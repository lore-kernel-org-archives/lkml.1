Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbXFCUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbXFCUs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFCUr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:47:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56092 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbXFCUr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:47:28 -0400
Date: Sun, 3 Jun 2007 22:48:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 13/19] kbuild: ignore section mismatch warnings originating from .note section
Message-ID: <20070603204829.GN9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 13/19] kbuild: ignore section mismatch warnings originating from .note section
From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 29 May 2007 23:09:35 +0200

.note* sections are ELF notes, which are typically used by external
tools to examine the kernel image.  Since this is removed from any
runtime consideration, it's OK to reference any section from a .note*
section.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 662deba..b824198 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1139,6 +1139,7 @@ static int init_section_ref_ok(const char *name)
 		".debug",
 		".parainstructions",
 		".rodata",
+		".note",		/* ignore ELF notes - may contain anything */
 		NULL
 	};
 	/* part of section name */
@@ -1214,6 +1215,7 @@ static int exit_section_ref_ok(const char *name)
 	/* Start of section names */
 	const char *namelist2[] = {
 		".debug",
+		".note",		/* ignore ELF notes - may contain anything */
 		NULL
 	};
 	/* part of section name */
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
