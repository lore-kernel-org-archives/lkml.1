Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbYBBWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbYBBWh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762650AbYBBWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:37:51 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55751 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762588AbYBBWhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:37:50 -0500
Date: Sat, 2 Feb 2008 23:37:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [Additional PATCH] kbuild: do not warn about __*init/__*exit symbols being exported
Message-ID: <20080202223753.GB27546@uranus.ravnborg.org>
References: <20080202203503.GA26415@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202203503.GA26415@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e01639fd02bcf0126fcdedd09536a060e2593f07 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 2 Feb 2008 23:30:22 +0100
Subject: [PATCH] kbuild: do not warn about __*init/__*exit symbols being exported

We have several legitimate uses where we export symbols
annotated with one of:
__devinit, __cpuinit, __meminit and their exit counterpart.
So let's stop warning about those being exported in favour
of adding all sorts of workaround to silence the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c2e918e..5d54646 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -870,7 +870,7 @@ const struct sectioncheck sectioncheck[] = {
 /* Do not export init/exit functions or data */
 {
 	.fromsec = { "__ksymtab*", NULL },
-	.tosec   = { ALL_INIT_SECTIONS, ALL_EXIT_SECTIONS, NULL },
+	.tosec   = { INIT_SECTIONS, EXIT_SECTIONS, NULL },
 	.mismatch = EXPORT_TO_INIT_EXIT
 }
 };
-- 
1.5.4.rc3.14.g44397

