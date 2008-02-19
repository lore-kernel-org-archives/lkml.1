Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYBSULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYBSULT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYBSULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:11:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33040 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYBSULF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:11:05 -0500
Date: Tue, 19 Feb 2008 21:11:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [GIT PULL] 2 x kbuild fixes
Message-ID: <20080219201114.GA12272@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull two kbuild fixes from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-linus.git

Note - new git tree to avoid clash with new stuff.
Full diff below the details.

	Sam


Geert Uytterhoeven (1):
      kbuild: fix reversed symbol name order in modpost

Sam Ravnborg (1):
      Add missing init section definitions

 include/asm-generic/vmlinux.lds.h |    3 +++
 include/linux/init.h              |    2 ++
 scripts/mod/modpost.c             |    2 +-
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f784d2f..f054778 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -238,6 +238,9 @@
 		*(.kprobes.text)					\
 		VMLINUX_SYMBOL(__kprobes_text_end) = .;
 
+/* Section used for early init (in .S files) */
+#define HEAD_TEXT  *(.head.text)
+
 /* init and exit section handling */
 #define INIT_DATA							\
 	*(.init.data)							\
diff --git a/include/linux/init.h b/include/linux/init.h
index a404a00..fb58c04 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -42,6 +42,7 @@
    discard it in modules) */
 #define __init		__section(.init.text) __cold
 #define __initdata	__section(.init.data)
+#define __initconst	__section(.init.rodata)
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 
@@ -106,6 +107,7 @@
 #define __memexitconst   __section(.memexit.rodata)
 
 /* For assembly routines */
+#define __HEAD		.section	".head.text","ax"
 #define __INIT		.section	".init.text","ax"
 #define __FINIT		.previous
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6174277..695b5d6 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1200,7 +1200,7 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		"annotate %s with a matching annotation.\n",
 		from, sec2annotation(fromsec), fromsym, from_p,
 		to, sec2annotation(tosec), tosym, to_p,
-		fromsym, tosym, fromsym);
+		tosym, fromsym, tosym);
 		break;
 	case INIT_TO_EXIT:
 		fprintf(stderr,

