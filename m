Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbYDYTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbYDYTTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYDYTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:19:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59077 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbYDYTTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:19:30 -0400
Date: Fri, 25 Apr 2008 21:20:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] kbuild patches for merge window
Message-ID: <20080425192002.GA11509@uranus.ravnborg.org>
References: <20080425185605.GA10902@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425185605.GA10902@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Forgot two patches which I applied on top of the others.

> Pull from:
> 
>    master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git
> 

	Sam

Mike Frysinger (1):
      kbuild: silence documentation GEN xml messages according to $(quiet)

Sam Ravnborg (1):
      kconfig: fix broken target update-po-config

 Documentation/DocBook/Makefile |    5 ++++-
 scripts/kconfig/Makefile       |    4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)
diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index b2b6366..83966e9 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -187,8 +187,11 @@ quiet_cmd_fig2png = FIG2PNG $@
 
 ###
 # Rule to convert a .c file to inline XML documentation
+       gen_xml = :
+ quiet_gen_xml = echo '  GEN     $@'
+silent_gen_xml = :
 %.xml: %.c
-	@echo '  GEN     $@'
+	@$($(quiet)gen_xml)
 	@(                            \
 	   echo "<programlisting>";   \
 	   expand --tabs=8 < $< |     \
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 32e8c5a..fa1a7d5 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -36,10 +36,10 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
 	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
-	$(Q)(for i in `ls arch/`;                        \
+	$(Q)(for i in `ls arch/*/Kconfig`;               \
 	    do                                           \
 		echo "  GEN $$i";                        \
-		$(obj)/kxgettext arch/$$i/Kconfig        \
+		$(obj)/kxgettext $$i                     \
 		     >> $(obj)/config.pot;               \
 	    done )
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
