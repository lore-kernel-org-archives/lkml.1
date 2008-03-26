Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYCZBQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYCZBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYCZBQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:16:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32188 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYCZBQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=Rj8GvwsHIuxcA5vo3FUhgnSBcMqlc7GyluFJrii4RyjEPbdI25S4H+epZ5adn3m4LyQ5+XEndKAOW2IPF4wDXYn+SOxdsGQPoCp5dinDfWHgigQSzTfd7UJmqv2rg6yGUkSIdt1efJ0lzC9BYTpKnBlCbccxJR1ffUoFfPV4naE=
Date: Wed, 26 Mar 2008 02:16:15 +0100 (CET)
To: LKML <linux-kernel@vger.kernel.org>
cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Molton <spyro@f2s.com>,
       Alain L Knaff <Alain.Knaff@lll.lu>, David C Niemi <niemi@tux.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86 floppy: kill off the 'register' keyword from header
Message-ID: <alpine.LNX.1.00.0803260214551.1901@dragon.funnycrock.com>
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

This patch does away with a few register keywords in the x86 floppy driver.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/floppy.h b/include/asm-x86/floppy.h
index a48d715..31b0d80 100644
--- a/include/asm-x86/floppy.h
+++ b/include/asm-x86/floppy.h
@@ -52,7 +52,7 @@ static int doing_pdma;
 
 static irqreturn_t floppy_hardint(int irq, void *dev_id)
 {
-	register unsigned char st;
+	unsigned char st;
 
 #undef TRACE_FLPY_INT
 
@@ -70,8 +70,8 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 #endif
 
 	{
-		register int lcount;
-		register char *lptr;
+		int lcount;
+		char *lptr;
 
 		st = 1;
 		for(lcount=virtual_dma_count, lptr=virtual_dma_addr;

