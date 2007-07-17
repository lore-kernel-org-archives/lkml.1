Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbXGQOSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbXGQOSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763849AbXGQOIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55805 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761155AbXGQOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:51 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 24/33] Whitelist references from __dbe_table to .init
Date: Tue, 17 Jul 2007 16:08:53 +0200
Message-Id: <11846813441741-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <118468134441-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>

This is needed on MIPS where the same mechanism as get_user() is used to
intercept bus error exceptions for some hardware probes.  Without this
patch modpost will throw spurious warnings:

  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: arch/mips/sgi-ip22/built-in.o(__dbe_table+0x0): Section mismatch: reference to .init.text:

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3f3848f..04579a5 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1141,6 +1141,7 @@ static int init_section_ref_ok(const char *name)
 	const char **s;
 	/* Absolute section names */
 	const char *namelist1[] = {
+		"__dbe_table",		/* MIPS generate these */
 		"__ftr_fixup",		/* powerpc cpu feature fixup */
 		"__fw_ftr_fixup",	/* powerpc firmware feature fixup */
 		"__param",
-- 
1.5.0.6

