Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbXLMWUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbXLMWUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXLMWUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:20:43 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39534 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755252AbXLMWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:20:42 -0500
Date: Thu, 13 Dec 2007 23:20:44 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Subject: RFC: remove __read_mostly
Message-ID: <20071213222044.GH21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried the following patch with a full x86 .config [1]:

--- a/include/asm-x86/cache.h
+++ b/include/asm-x86/cache.h
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+/* #define __read_mostly __attribute__((__section__(".data.read_mostly"))) */

The result [2,3] was:

-rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
-rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux

It's not a surprise that the kernel can become bigger when __read_mostly 
gets used, especially in cases where __read_mostly prevents gcc 
optimizations.

My question is:
Is there anywhere in the kernel a case where __read_mostly brings a 
measurable improvement or can it be removed?

cu
Adrian

[1] mostly allyesconfig with CONFIG_MODULES=n
[2] vmlinux.old is the unpatched kernel
[3] gcc 4.2 was used

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

