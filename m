Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883Ab0ALB0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0ALB0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233Ab0ALB0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:26:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab0ALB0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:26:42 -0500
Date: Mon, 11 Jan 2010 17:26:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <20100112121434.49930eea.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1001111720290.17145@localhost.localdomain>
References: <20100112121434.49930eea.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jan 2010, Stephen Rothwell wrote:
> 
> I then got these:
> 
> lib/decompress_unlzo.c: In function 'unlzo':
> lib/decompress_unlzo.c:106: error: 'error' undeclared (first use in this function)
> lib/decompress_unlzo.c:111: error: implicit declaration of function 'error'
> 
> So I just reverted commit
> cacb246f8db2b9eba89d44a0f0dd4f6ed93bc113 ("Add LZO compression support
> for initramfs and old-style initrd") after removing my fix above.

Hmm. I think the real problem is that it allowed LZO to be enabled at all, 
despite HAVE_KERNEL_LZO not being enabled.

In other words, I think the config dependencies for RD_LZO are just 
totally broken.

Does this work for you?

(Totally untested and not very much thought about, this is just a "that 
looks really _wrong_" kind of patch)

		Linus

---
 usr/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/usr/Kconfig b/usr/Kconfig
index e2721f5..0254cce 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -75,7 +75,7 @@ config RD_LZMA
 config RD_LZO
 	bool "Support initial ramdisks compressed using LZO" if EMBEDDED
 	default !EMBEDDED
-	depends on BLK_DEV_INITRD
+	depends on BLK_DEV_INITRD && HAVE_KERNEL_LZO
 	select DECOMPRESS_LZO
 	help
 	  Support loading of a LZO encoded initial ramdisk or cpio buffer
