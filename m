Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZJRILU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZJRILU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZJRILT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:11:19 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50898 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZJRILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:18 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 01/14] kbuild: search arch/$ARCH/include before include/
Date: Sun, 18 Oct 2009 10:15:10 +0200
Message-Id: <1255853723-477-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The namespace used in arch/$ARCH/include is different from
what is used in include/ except for the include/asm directory.

This patch gives the arch/$ARCH/include/asm directory priority
over include/asm.

When we add asm-offsets.h to arch/$ARCH/include/asm/ this
patch makes sure we pick up the arch specific version
and not the one we have in include/asm.

The situation with an asm-offsets.h file located in
both include/asm _and_ arch/$ARCH/include/asm will happen
when we move more files over to include/generated.

This happens because in some cases it is not practical
to rename all users so we simply add a file
in arch/$ARCH/include/asm that includes the generated version.

This is the solution we use for asm-offsets.h as an example.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 9425d1d..a805f5c 100644
--- a/Makefile
+++ b/Makefile
@@ -334,9 +334,8 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
-LINUXINCLUDE    := -Iinclude \
+LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
-                   -I$(srctree)/arch/$(hdr-arch)/include               \
                    -include include/linux/autoconf.h
 
 KBUILD_CPPFLAGS := -D__KERNEL__
-- 
1.6.2.5

