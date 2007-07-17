Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbXGQOUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbXGQOUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764013AbXGQOIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:25 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35933 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761127AbXGQOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH 15/33] kbuild: ignore section mismatch warnings originating from .note section
Date: Tue, 17 Jul 2007 16:08:44 +0200
Message-Id: <11846813443387-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813441521-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
index ece09c5..9c35f30 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1152,6 +1152,7 @@ static int init_section_ref_ok(const char *name)
 		".debug",
 		".parainstructions",
 		".rodata",
+		".note",		/* ignore ELF notes - may contain anything */
 		NULL
 	};
 	/* part of section name */
@@ -1228,6 +1229,7 @@ static int exit_section_ref_ok(const char *name)
 	/* Start of section names */
 	const char *namelist2[] = {
 		".debug",
+		".note",		/* ignore ELF notes - may contain anything */
 		NULL
 	};
 	/* part of section name */
-- 
1.5.0.6

