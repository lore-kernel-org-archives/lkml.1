Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbYCZBRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbYCZBRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761891AbYCZBRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:17:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32669 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761823AbYCZBRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:17:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=DL1rWDyhZetHKyrt742IghZEg2YwFoQoAKiEILgNvKFiQOq+SoJPzWC0nis71F3eOK2YVzawVgOBqWNSgMKNcBgMZmqzcM6lPkX9DGJ7s2DWSPe63dKToaY5+0OKFCDe7jNIRgQCvgDXEkaXYETlSiw0yLalessb3A8N4J44xo4=
Date: Wed, 26 Mar 2008 02:17:03 +0100 (CET)
To: LKML <linux-kernel@vger.kernel.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       Ian Molton <spyro@f2s.com>, Alain L Knaff <Alain.Knaff@lll.lu>,
       David C Niemi <niemi@tux.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] m68k floppy: kill 'register' keyword from header
Message-ID: <alpine.LNX.1.00.0803260202380.1901@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When compilers became generally better at optimizing code than humans, the
register keyword became mostly useless. For the floppy driver it certainly
is since it's so slow compared to the rest of the system that optimizing
access to a single variable or two isn't going to make any real
difference
So let's just leave it to the compiler - it'll do a better job anyway.

This patch does away with a few register keywords in the m68k floppy driver.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-m68k/floppy.h b/include/asm-m68k/floppy.h
index 697d503..18efe25 100644
--- a/include/asm-m68k/floppy.h
+++ b/include/asm-m68k/floppy.h
@@ -182,7 +182,7 @@ static void fd_disable_dma(void)
 
 asmlinkage irqreturn_t floppy_hardint(int irq, void *dev_id)
 {
-	register unsigned char st;
+	unsigned char st;
 
 #undef TRACE_FLPY_INT
 #define NO_FLOPPY_ASSEMBLER
@@ -203,8 +203,8 @@ asmlinkage irqreturn_t floppy_hardint(int irq, void *dev_id)
 #endif
 
 	{
-		register int lcount;
-		register char *lptr;
+		int lcount;
+		char *lptr;
 
 		/* serve 1st byte fast: */
 


