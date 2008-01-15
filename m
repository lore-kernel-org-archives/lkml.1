Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYAOBFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYAOBFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYAOBEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:04:53 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:36853 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYAOBEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:04:52 -0500
Date: Tue, 15 Jan 2008 02:04:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix 32bit build for git-x86
Message-ID: <20080115010449.GA5521@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Jan 2008 00:58:39.0114 (UTC) FILETIME=[C3CD6EA0:01C85711]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes the 32build here with git-x86 (tip 2f42671697ea9abc7d10ea7f663d6ef6e8ec6358)

Fix git-x86 build 

Otherwise

make[3]: Nothing to be done for `vmlinux'.
KBUILD_IMAGE := arch/x86/boot/bzImage
make[2]: KBUILD_IMAGE: Command not found
make[2]: *** [all] Error 127

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/Makefile
===================================================================
--- linux.orig/arch/x86/Makefile
+++ linux/arch/x86/Makefile
@@ -211,7 +211,8 @@ PHONY += zImage bzImage compressed zlilo
 all: bzImage
 
 # KBUILD_IMAGE specify target image being built
-		    KBUILD_IMAGE := $(boot)/bzImage
+KBUILD_IMAGE := $(boot)/bzImage
+
 zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
 
 zImage bzImage: vmlinux
