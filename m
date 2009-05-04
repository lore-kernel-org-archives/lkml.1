Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZEDL6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZEDL6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZEDL61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:58:27 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46325 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbZEDL60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:58:26 -0400
Date: Mon, 4 May 2009 14:00:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sean MacLennan <smaclennan@pikatech.com>, Anders Kaseorg <andersk@mit.edu>,
       Jean Delvare <khali@linux-fr.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, Wolfgang Denk <wd@denx.de>
Subject: [PATCH 2/3] kbuild, modpost: fix "unexpected non-allocatable" warning with SUSE gcc
Message-ID: <20090504120025.GB7239@uranus.ravnborg.org>
References: <20090504115704.GA7134@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504115704.GA7134@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 028ecebdd83cc4a7f8c7e96e28a5537d2ac98dae Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 May 2009 22:17:37 +0200
Subject: [PATCH 2/3] kbuild, modpost: fix "unexpected non-allocatable" warning with SUSE gcc

Jean reported that he saw one warning for each module like the one below:
WARNING: arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.o (.comment.SUSE.OPTs): unexpected non-allocatable section.

The warning appeared with the improved version of the
check of the flags in the sections.

That check already ignored sections named ".comment" - but SUSE store
additional info in the comment section and has named it in a SUSE
specific way. Therefore modpost failed to ignore the section.

The fix is to extend the pattern so we ignore all sections
that start with the name ".comment.".

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Jean Delvare <khali@linux-fr.org>
---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a5c17db..268d457 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -727,7 +727,7 @@ int match(const char *sym, const char * const pat[])
 
 /* sections that we do not want to do full section mismatch check on */
 static const char *section_white_list[] =
-	{ ".comment", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
+	{ ".comment*", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
 
 /*
  * This is used to find sections missing the SHF_ALLOC flag.
-- 
1.6.3.rc3.40.g75b44

