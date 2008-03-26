Return-Path: <linux-kernel-owner+w=401wt.eu-S1761142AbYCZBQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142AbYCZBQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbYCZBQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:16:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32669 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbYCZBQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=QaK5oEWZnKS/GnZYmdsckYzsBtdfw1lnXrQeCymQFV3cQMgoU8CevsHmQLKBsg4uecg1lnbOt4s0j4d/UrP2ESRmh06Ss6s8dbcmS9bislek/Pv5isQ9HTpdGygwWopAG8mJjSdmi/8vazjFmVF+YJFO8+ArHenQGnyvjnvkfcU=
Date: Wed, 26 Mar 2008 02:16:32 +0100 (CET)
To: LKML <linux-kernel@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       Ian Molton <spyro@f2s.com>, Alain L Knaff <Alain.Knaff@lll.lu>,
       David C Niemi <niemi@tux.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] SuperH floppy: kill 'register' keyword from floppy.h
 header
Message-ID: <alpine.LNX.1.00.0803260213550.1901@dragon.funnycrock.com>
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

This patch does away with a few register keywords in the SuperH floppy
driver.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-sh/floppy.h b/include/asm-sh/floppy.h
index 59fbfdc..afa7f8f 100644
--- a/include/asm-sh/floppy.h
+++ b/include/asm-sh/floppy.h
@@ -54,7 +54,7 @@ static int doing_pdma;
 
 static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 {
-	register unsigned char st;
+	unsigned char st;
 
 #undef TRACE_FLPY_INT
 
@@ -74,8 +74,8 @@ static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 #endif
 
 	{
-		register int lcount;
-		register char *lptr;
+		int lcount;
+		char *lptr;
 
 		st = 1;
 		for(lcount=virtual_dma_count, lptr=virtual_dma_addr; 



