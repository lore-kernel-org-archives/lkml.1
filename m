Return-Path: <linux-kernel-owner+w=401wt.eu-S1765476AbXGKRRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765476AbXGKRRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbXGKRRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:17:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:44818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbXGKRRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=enx9/tu2b+RakRX6n00geaPVam+OdgKGHRwxOWaaf0NNN0xjfK7tu488nZpdLP5zRJILVOf0Ssi27oblTNBU5JIAG35unWeTfn535EuWWuk3dymuBravfDBPvqs/d0ZBomsdrQAbVfB+TW8VmcNWbe90o32lr0TdjWhBrLVJjT8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Date: Wed, 11 Jul 2007 19:16:34 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111916.35036.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm wondering if it's time to make 4K stacks the default and to start 
considering removing the 8K stack option alltogether soon?

One of the big problem spots was XFS, but that got some stack usage 
fixes recently, and the 4K stack option has been around for quite a 
while now, so people really should have gotten around to fixing any 
code that can't handle it.   Are there still any big problem areas 
remaining?

As a starting point, something like the patch below that makes 4K 
stacks default and make them no longer depend on DEBUG_KERNEL 
could be the way to go. Then after a while of this being in effect we 
could remove the option of a 8K stack alltogether.

What say you?


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 arch/i386/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index b31c080..9b23bff 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
@@ -58,7 +58,7 @@ config DEBUG_RODATA
 
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on DEBUG_KERNEL
+	default y
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates




-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html


