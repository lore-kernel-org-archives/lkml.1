Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYBKNcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYBKNcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYBKNb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:31:58 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39411 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYBKNb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:31:57 -0500
Date: Mon, 11 Feb 2008 14:31:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: Linux 2.6.25-rc1
Message-ID: <20080211133137.GB20959@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

A kbuild bug sneaked in. Please pull from:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

to fix the following bug.

	Sam

>From 49af821e4b1c07e756cbc2e389eba9d885912602 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 11 Feb 2008 14:26:26 +0100
Subject: [PATCH] kbuild: fix make V=1

When make -s support were added to filechk to
combination created with make V=1 were not
covered.
Fix it by explicitly cover this case too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 scripts/Kbuild.include |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index da3559e..d64e6ba 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -39,10 +39,13 @@ escsq = $(subst $(squote),'\$(squote)',$1)
 # - If they are equal no change, and no timestamp update
 # - stdin is piped in from the first prerequisite ($<) so one has
 #   to specify a valid file as first prerequisite (often the kbuild file)
+       chk_filechk = :
  quiet_chk_filechk = echo '  CHK     $@'
 silent_chk_filechk = :
+       upd_filechk = :
  quiet_upd_filechk = echo '  UPD     $@'
 silent_upd_filechk = :
+
 define filechk
 	$(Q)set -e;				\
 	$($(quiet)chk_filechk);			\
-- 
1.5.4.rc3.14.g44397

