Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZEDL7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZEDL7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZEDL7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:59:36 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46899 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZEDL7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:59:35 -0400
Date: Mon, 4 May 2009 14:01:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sean MacLennan <smaclennan@pikatech.com>, Anders Kaseorg <andersk@mit.edu>,
       Jean Delvare <khali@linux-fr.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, Wolfgang Denk <wd@denx.de>
Subject: [PATCH 3/3] kbuild, modpost: fix unexpected non-allocatable warning with mips
Message-ID: <20090504120106.GC7239@uranus.ravnborg.org>
References: <20090504115704.GA7134@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504115704.GA7134@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4391ed6aa9a38cdfb48addd7a9b24a2ff099b1a7 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 4 May 2009 13:05:26 +0200
Subject: [PATCH 3/3] kbuild, modpost: fix unexpected non-allocatable warning with mips

mips emit the following debug sections:
.mdebug* and .pdr

They were included in the check for non-allocatable section
and caused modpost to warn.

Manuel Lauss suggested to fix this by adding the relevant
sections to the list of sections we do not check.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 scripts/mod/modpost.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 268d457..161b784 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -727,7 +727,17 @@ int match(const char *sym, const char * const pat[])
 
 /* sections that we do not want to do full section mismatch check on */
 static const char *section_white_list[] =
-	{ ".comment*", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
+{
+	".comment*",
+	".debug*",
+	".mdebug*",        /* alpha, score, mips etc. */
+	".pdr",            /* alpha, score, mips etc. */
+	".stab*",
+	".note*",
+	".got*",
+	".toc*",
+	NULL
+};
 
 /*
  * This is used to find sections missing the SHF_ALLOC flag.
-- 
1.6.3.rc3.40.g75b44

