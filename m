Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbXGWIM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbXGWIM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbXGWIMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:12:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbXGWIMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:12:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: "Sam Ravnborg <sam@ravnborg.org>Adrian Bunk" <bunk@stusta.de>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] Use LDFLAGS_MODULE only for .ko links
In-Reply-To: Sam Ravnborg's message of  Monday, 23 July 2007 08:42:35 +0200 <20070723064235.GA4129@uranus.ravnborg.org>
X-Zippy-Says: ...Get me a GIN and TONIC!!...make it HAIR TONIC!!
Message-Id: <20070723081208.088674D058D@magilla.localdomain>
Date: Mon, 23 Jul 2007 01:12:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces the "Move --build-id option" patch.

Thanks,
Roland

---

Sam Ravnborg pointed out that Documentation/kbuild/makefiles.txt already
says this is what it's for.  This patch makes the reality live up to the
documentation.  This fixes the problem of LDFLAGS_BUILD_ID getting into too
many places.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Makefile                 |    2 +-
 scripts/Makefile.build   |    2 +-
 scripts/Makefile.modpost |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index cd47845..f510c39 100644
--- a/Makefile
+++ b/Makefile
@@ -299,7 +299,7 @@ CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise $(C
 MODFLAGS	= -DMODULE
 CFLAGS_MODULE   = $(MODFLAGS)
 AFLAGS_MODULE   = $(MODFLAGS)
-LDFLAGS_MODULE  = -r
+LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 3f7b451..7fd6055 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -315,7 +315,7 @@ quiet_cmd_link_multi-y = LD      $@
 cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps)
 
 quiet_cmd_link_multi-m = LD [M]  $@
-cmd_link_multi-m = $(LD) $(ld_flags) $(LDFLAGS_MODULE) -o $@ $(link_multi_deps)
+cmd_link_multi-m = $(cmd_link_multi-y)
 
 # We would rather have a list of rules like
 # 	foo.o: $(foo-objs)
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index c6fcc59..149e604 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -97,7 +97,7 @@ targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
+      cmd_ld_ko_o = $(LD) -r $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
 			  $(filter-out FORCE,$^)
 
 $(modules): %.ko :%.o %.mod.o FORCE
