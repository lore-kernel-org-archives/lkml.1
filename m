Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXGKTFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXGKTFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbXGKTFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:05:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760370AbXGKTFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:05:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 7/7] Use --build-id ld option
Emacs: no job too big... no job.
Message-Id: <20070711190533.B68534D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 12:05:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This change passes the --build-id when linking the kernel and when
linking modules, if ld supports it.  This is a new GNU ld option that
synthesizes an ELF note section inside the read-only data.  The note in
this section contains unique identifying bits called the "build ID",
which are generated so as to be different for any two linked ELF files
that aren't identical.  The build ID can be recovered from stripped
files, memory dumps, etc. and used to look up the original program
built, locate debuginfo or other details or history associated with it.
For normal program linking, the compiler passes --build-id to ld by
default, but the option is needed when using ld directly as we do.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Makefile |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 88b2252..1e11ceb 100644
--- a/Makefile
+++ b/Makefile
@@ -514,6 +514,12 @@ CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 # disable pointer signed / unsigned warnings in gcc 4.0
 CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
+# Use --build-id when available.
+LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
+			      $(call ld-option, -Wl$(comma)--build-id,))
+LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
+LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
+
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
 # set in the environment
