Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYDFMrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYDFMrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 08:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYDFMrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 08:47:46 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:5681 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYDFMrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 08:47:45 -0400
Date: Sun, 6 Apr 2008 14:47:00 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: [PATCH] x86: remove superfluous initialisation in boot code.
Message-ID: <20080406124700.GA26669@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 06 Apr 2008 14:47:31 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.122; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: remove superfluous initialisation in boot code.

In arch/x86/boot/compressed/misc.c, the variable vidmem is
the only variable that ends up in de data segment. It's also
superfluous, because the first thing the code does is:

	if (RM_SCREEN_INFO.orig_video_mode == 7) {
		vidmem = (char *) 0xb0000;
		vidport = 0x3b4;
	} else {
		vidmem = (char *) 0xb8000;
		vidport = 0x3d4;
	}

This patch removes the initialisation.

---

Tested on qemu (i386 and x86_64). The boot messages still
appear as usual:

Decompressing Linux... Parsing ELF... done.
Booting the kernel.

Greetings,
	Alexander

 arch/x86/boot/compressed/misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 9470a05..dad4e69 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -223,7 +223,7 @@ static memptr free_mem_end_ptr;
 #define HEAP_SIZE             0x4000
 #endif
 
-static char *vidmem = (char *)0xb8000;
+static char *vidmem;
 static int vidport;
 static int lines, cols;
 
