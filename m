Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYAQVtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYAQVtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbYAQVoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:44:12 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43964 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945AbYAQVoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:44:10 -0500
Date: Thu, 17 Jan 2008 23:43:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080117214301.GA28233@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently someone told me he had a bug on x86 and to reproduce
it I should "'make allyesconfig' and disable CONFIG_HOTPLUG=y".

But I didn't see it.

"make allyesconfig" is ambiguous on x86 and he had a 64bit computer.

There go another two hours compile time.

It makes sense to have the Kconfig default and the defconfig based on 
whether you are on a 32bit or a 64bit machine, but it's complete 
nonsense to not offer the Kconfig variable unless you had explicitely 
given ARCH=x86 (in which case you could as well immediately set the ARCH 
to i386 or x86_64).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
fcf848366a166812fa32b2a22f2631fcd4982cb4 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80b7ba4..0e6e74d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -3,7 +3,7 @@ mainmenu "Linux Kernel Configuration for x86"
 
 # Select 32 or 64 bit
 config 64BIT
-	bool "64-bit kernel" if ARCH = "x86"
+	bool "64-bit kernel"
 	default ARCH = "x86_64"
 	help
 	  Say yes to build a 64-bit kernel - formerly known as x86_64

