Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZIKTpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZIKTpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbZIKTpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:45:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbZIKTpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:45:44 -0400
Date: Fri, 11 Sep 2009 21:45:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/kbuild for v2.6.32
Message-ID: <20090911194537.GA29950@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-kbuild-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-kbuild-for-linus

 Thanks,

	Ingo

------------------>
Frans Pop (1):
      x86: Simplify the Makefile in a minor way through use of cc-ifversion


 arch/x86/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..1f3851a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -32,8 +32,8 @@ ifeq ($(CONFIG_X86_32),y)
 
         # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
         # a lot more stack due to the lack of sharing of stacklots:
-        KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
-                echo $(call cc-option,-fno-unit-at-a-time); fi ;)
+        KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0400, \
+				$(call cc-option,-fno-unit-at-a-time))
 
         # CPU-specific tuning. Anything which can be shared with UML should go here.
         include $(srctree)/arch/x86/Makefile_32.cpu
