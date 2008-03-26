Return-Path: <linux-kernel-owner+w=401wt.eu-S1761799AbYCZBQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761799AbYCZBQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760727AbYCZBQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:16:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32188 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760713AbYCZBQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=baZdR1xrh47c2Zmq2x6ruaOgrOXuIg2SpTAfVBEmxTc41OF1rffn3bTH1fboZ7IBC+SqFegN9+NDfx0QW62u1eV9vZmuPm+jIJ0A8Fj38ij1xCjEIKEDKm+YNbyJ0QAqc059xhuD6ZmVM2dyTsXwwI821GMYWYTLJjklVsAjmLk=
Date: Wed, 26 Mar 2008 02:16:42 +0100 (CET)
To: LKML <linux-kernel@vger.kernel.org>
cc: Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org, Ian Molton <spyro@f2s.com>,
       Alain L Knaff <Alain.Knaff@lll.lu>, David C Niemi <niemi@tux.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] parisc floppy: kill the 'register' keyword from header
Message-ID: <alpine.LNX.1.00.0803260212140.1901@dragon.funnycrock.com>
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

This patch does away with a few register keywords in the parisc floppy 
driver.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-parisc/floppy.h b/include/asm-parisc/floppy.h
index 4ca69f5..2f0a371 100644
--- a/include/asm-parisc/floppy.h
+++ b/include/asm-parisc/floppy.h
@@ -64,7 +64,7 @@ static int doing_pdma=0;
 
 static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 {
-	register unsigned char st;
+	unsigned char st;
 
 #undef TRACE_FLPY_INT
 
@@ -84,8 +84,8 @@ static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 #endif
 
 	{
-		register int lcount;
-		register char *lptr = virtual_dma_addr;
+		int lcount;
+		char *lptr = virtual_dma_addr;
 
 		for (lcount = virtual_dma_count; lcount; lcount--) {
 			st = fd_inb(virtual_dma_port+4) & 0xa0 ;


