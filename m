Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYLTOd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYLTOd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYLTOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:22 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56423 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYLTOaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:14 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 26/26] kbuild: support switching source directories with O=.. builds
Date: Sat, 20 Dec 2008 15:31:37 +0100
Message-Id: <1229783497-19550-26-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was not possible to use the same output directory
for two different source repositories becuase the asm
symlink in include2/asm would point to the first repository.

We now create the symlink each time thus allowing switch
between different source repositories.

This feature was requested by Andi Kleen.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index b3d1c8f..2da055c 100644
--- a/Makefile
+++ b/Makefile
@@ -961,8 +961,8 @@ ifneq ($(KBUILD_SRC),)
 	fi;
 	$(Q)if [ ! -d include2 ]; then                                  \
 	    mkdir -p include2;                                          \
-	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
 	fi
+	$(Q)ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm
 endif
 
 # prepare2 creates a makefile if using a separate output directory
-- 
1.6.0.2.GIT

