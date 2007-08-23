Return-Path: <linux-kernel-owner+w=401wt.eu-S1765355AbXHWXpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765355AbXHWXpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbXHWXpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:45:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:52132 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbXHWXpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=piQF9U2UsAWWRB3zhEBEI3qdQc8jOkD2pSPUQyW34YepKGaMMzmyGnba18nGSq8iqyYim8HQeiyVk/5tRe4I5Xe+LpREdCT62r0IiB0neNk63DzkuV+xto0DwA+6JnH5/Dz217GEGedfBHcUOKXh09oKRRoA4Msl1UA7i32KpUY=
Message-Id: <19063f792435ec0bc208ee967523169d9b1206a8.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:42:14 +0200
Subject: [PATCH 02/30] cris: Remove unnecessary cast of allocation return value in intmem.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <starvik@axis.com>, dev-etrax@axis.com,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() returns a void pointer so there's no need to cast the
return value.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 arch/cris/arch-v32/mm/intmem.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/cris/arch-v32/mm/intmem.c b/arch/cris/arch-v32/mm/intmem.c
index 41ee7f7..691cf3b 100644
--- a/arch/cris/arch-v32/mm/intmem.c
+++ b/arch/cris/arch-v32/mm/intmem.c
@@ -27,8 +27,8 @@ static void crisv32_intmem_init(void)
 {
 	static int initiated = 0;
 	if (!initiated) {
-		struct intmem_allocation* alloc =
-		  (struct intmem_allocation*)kmalloc(sizeof *alloc, GFP_KERNEL);
+		struct intmem_allocation *alloc =
+			kmalloc(sizeof *alloc, GFP_KERNEL);
 		INIT_LIST_HEAD(&intmem_allocations);
 		intmem_virtual = ioremap(MEM_INTMEM_START, MEM_INTMEM_SIZE);
 		initiated = 1;
@@ -55,8 +55,7 @@ void* crisv32_intmem_alloc(unsigned size, unsigned align)
 		if (allocation->status == STATUS_FREE &&
 		    allocation->size >= size + alignment) {
 			if (allocation->size > size + alignment) {
-				struct intmem_allocation* alloc =
-					(struct intmem_allocation*)
+				struct intmem_allocation *alloc =
 					kmalloc(sizeof *alloc, GFP_ATOMIC);
 				alloc->status = STATUS_FREE;
 				alloc->size = allocation->size - size - alignment;
@@ -64,8 +63,7 @@ void* crisv32_intmem_alloc(unsigned size, unsigned align)
 				list_add(&alloc->entry, &allocation->entry);
 
 				if (alignment) {
-					struct intmem_allocation* tmp;
-					tmp = (struct intmem_allocation*)
+					struct intmem_allocation *tmp =
 						kmalloc(sizeof *tmp, GFP_ATOMIC);
 					tmp->offset = allocation->offset;
 					tmp->size = alignment;
-- 
1.5.2.2

