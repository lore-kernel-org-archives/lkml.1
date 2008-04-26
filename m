Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbYDZTMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbYDZTMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbYDZTMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:12:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36023 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbYDZTMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:12:24 -0400
Date: Sat, 26 Apr 2008 21:12:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [GIT PULL] kbuild fixes
Message-ID: <20080426191256.GA784@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please apply the following two fixes by pulling from:

   master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git


The MODULE_LICENSE fix is neded to get an allmodconfig
build fixed.

	Sam


Adrian Bunk (1):
      kbuild: scripts/Makefile.modpost typo fix

Sam Ravnborg (1):
      kbuild: soften MODULE_LICENSE check

 scripts/Makefile.modpost |    2 +-
 scripts/mod/modpost.c    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 24b3c8f..a098a04 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -76,7 +76,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
- $(if $(iKBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
+ $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f8b42ab..757294b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1552,10 +1552,10 @@ static void read_symbols(char *modname)
 	}
 
 	license = get_modinfo(info.modinfo, info.modinfo_len, "license");
-	if (!license && !is_vmlinux(modname))
-		fatal("modpost: missing MODULE_LICENSE() in %s\n"
-		      "see include/linux/module.h for "
-		      "more information\n", modname);
+	if (info.modinfo && !license && !is_vmlinux(modname))
+		warn("modpost: missing MODULE_LICENSE() in %s\n"
+		     "see include/linux/module.h for "
+		     "more information\n", modname);
 	while (license) {
 		if (license_is_gpl_compatible(license))
 			mod->gpl_compatible = 1;
