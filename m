Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZFEXne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZFEXne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZFEXla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:30 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45067 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Cheng Renquan <crq@kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 22/39] kbuild: remove extra ifdef/endif of top Makefile
Date: Sat,  6 Jun 2009 01:42:40 +0200
Message-Id: <1244245377-17441-22-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crq@kernel.org>

The GNU make's origin function know undefined variable well,
so the outer ifdef/endif conditional checking is unneeded.

>From `info make` documentation, origin will return

  `undefined'
     if VARIABLE was never defined.
  `command line'
     if VARIABLE was defined on the command line.
   ...

Therefore, $(origin V) will get a value anyway, killing ifdef/endif is
viable and safe.

Furthermore, I've checked the minimal requirements from
Documentation/Changes is GNU make 3.79.1, and that version of GNU make
has support of origin function well already, so now it's safe to kill
the outer conditional checking, without upgrading the minimal
requirements.

Signed-off-by: Cheng Renquan <crq@kernel.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/Makefile b/Makefile
index 610d1c3..e270254 100644
--- a/Makefile
+++ b/Makefile
@@ -35,10 +35,8 @@ MAKEFLAGS += -rR --no-print-directory
 # To put more focus on warnings, be less verbose as default
 # Use 'make V=1' to see the full commands
 
-ifdef V
-  ifeq ("$(origin V)", "command line")
-    KBUILD_VERBOSE = $(V)
-  endif
+ifeq ("$(origin V)", "command line")
+  KBUILD_VERBOSE = $(V)
 endif
 ifndef KBUILD_VERBOSE
   KBUILD_VERBOSE = 0
@@ -54,10 +52,8 @@ endif
 # See the file "Documentation/sparse.txt" for more details, including
 # where to get the "sparse" utility.
 
-ifdef C
-  ifeq ("$(origin C)", "command line")
-    KBUILD_CHECKSRC = $(C)
-  endif
+ifeq ("$(origin C)", "command line")
+  KBUILD_CHECKSRC = $(C)
 endif
 ifndef KBUILD_CHECKSRC
   KBUILD_CHECKSRC = 0
@@ -69,12 +65,10 @@ endif
 ifdef SUBDIRS
   KBUILD_EXTMOD ?= $(SUBDIRS)
 endif
-ifdef M
-  ifeq ("$(origin M)", "command line")
-    KBUILD_EXTMOD := $(M)
-  endif
-endif
 
+ifeq ("$(origin M)", "command line")
+  KBUILD_EXTMOD := $(M)
+endif
 
 # kbuild supports saving output files in a separate directory.
 # To locate output files in a separate directory two syntaxes are supported.
@@ -98,10 +92,8 @@ ifeq ($(KBUILD_SRC),)
 
 # OK, Make called in directory where kernel src resides
 # Do we want to locate output files in a separate directory?
-ifdef O
-  ifeq ("$(origin O)", "command line")
-    KBUILD_OUTPUT := $(O)
-  endif
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
 endif
 
 # That's our default target when none is given on the command line
-- 
1.6.3.rc3.40.g75b44

