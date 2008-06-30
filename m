Return-Path: <linux-kernel-owner+w=401wt.eu-S933555AbYF3Vlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbYF3Vlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbYF3Vew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51670 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763187AbYF3Vee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:34 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 17/24] kbuild: sparse needs CF not CHECKFLAGS
Date: Mon, 30 Jun 2008 23:35:11 +0200
Message-Id: <1214861718-32626-17-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Documentation/sparse.txt tells to use:

    make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"

However, this still doesn't enable endian checks. The correct syntax is:

    make C=2 CF="-D__CHECK_ENDIAN__"

This documentation bug was introduced by the following commit:

    commit 1c7bafe7206d928eaccbcbd08d868733e0fb7054
    Author: Robert P. J. Day <rpjday@mindspring.com>
    Date:   Wed Sep 13 07:57:50 2006 -0400

	kbuild: clarify "make C=" build option

	Clarify the use of "make C=" in the top-level Makefile, and fix a
	typo in the Documentation file.

	Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

This `typo' was not a typo, as `CF' had been introduced much earlier, by:

    commit 7b49bb9aff8b14d15da58111d8908c877c0a525e
    Author: viro@ZenIV.linux.org.uk <viro@ZenIV.linux.org.uk>
    Date:   Fri Sep 9 21:14:35 2005 +0100

	[PATCH] kbuild: CF=<arguments> passes arguments to sparse

	Allows to add to sparse arguments without mutilating makefiles - just
	pass CF=<arguments> and they will be added to CHECKFLAGS.

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/sparse.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/sparse.txt b/Documentation/sparse.txt
index 1a3bdc2..42f43fa 100644
--- a/Documentation/sparse.txt
+++ b/Documentation/sparse.txt
@@ -73,10 +73,10 @@ recompiled, or use "make C=2" to run sparse on the files whether they need to
 be recompiled or not.  The latter is a fast way to check the whole tree if you
 have already built it.
 
-The optional make variable CHECKFLAGS can be used to pass arguments to sparse.
-The build system passes -Wbitwise to sparse automatically.  To perform
-endianness checks, you may define __CHECK_ENDIAN__:
+The optional make variable CF can be used to pass arguments to sparse.  The
+build system passes -Wbitwise to sparse automatically.  To perform endianness
+checks, you may define __CHECK_ENDIAN__:
 
-        make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"
+        make C=2 CF="-D__CHECK_ENDIAN__"
 
 These checks are disabled by default as they generate a host of warnings.
-- 
1.5.6.1.93.gef98

