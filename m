Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbYARTDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbYARTDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYARTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:02:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53524 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761246AbYARTCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:02:55 -0500
Date: Fri, 18 Jan 2008 20:03:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH for -rc] kbuild: fix false section mismatch warning referring to .init.text.2
Message-ID: <20080118190302.GA20285@uranus.ravnborg.org>
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking> <20080118132242.GA18183@uranus.ravnborg.org> <20080118161452.GJ2559@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080118161452.GJ2559@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull following two-liner fix for modpost.
It silence an annoying section mismatch warning.

Pull from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/fix-kbuild.git

	Sam


>From 57ff41164d27cb577620a6e8085dd67cd8a87649 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 18 Jan 2008 19:54:51 +0100
Subject: [PATCH] kbuild: fix false section mismatch warning referring to .init.text.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

The following section mismatch warning are false:
WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')

The problem was that modpost did not see a section named
".init.text.1" as an init section and thus it warned.

This patch fixes this so we no loneg see this warning.
Thanks to report from: Toralf Förster

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Toralf Förster <toralf.foerster@gmx.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
---
 scripts/mod/modpost.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 93ac52a..b5f1cff 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -736,8 +736,8 @@ static int secref_whitelist(const char *modname, const char *tosec,
 
 	/* Check for pattern 3 */
 	if ((strcmp(fromsec, ".text.head") == 0) &&
-		((strcmp(tosec, ".init.data") == 0) ||
-		(strcmp(tosec, ".init.text") == 0)))
+		((strncmp(tosec, ".init.data", strlen(".init.data")) == 0) ||
+		(strncmp(tosec, ".init.text", strlen(".init.text")) == 0)))
 	return 1;
 
 	/* Check for pattern 4 */
-- 
1.5.4.rc3.14.g44397

