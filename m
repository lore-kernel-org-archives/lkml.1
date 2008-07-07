Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYGGH4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYGGH4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYGGH4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:56:04 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:28753 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751272AbYGGH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:56:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=cHjGinD1IaH5AcYeXdBBxigDRofEiUdZTz/wIsGYweGxOFzCesai8M3eY+kdjY4CQ/DCj9Pxt9UF1QYiGyzLVkta2CVeYty7PlHjfmefL8gmKnGUparq/OCvV4eyPaoszgX+5+gBiv7McRPCBxndRL4/eXs6+VphSs4PTqEqeDY=  ;
X-YMail-OSG: qQMw5ocVM1kEkCy63rrpVc8YtWqeJlWAiHNcVFS5VW9fM.234ORI7p3qZcz3XLG3UPHkNhhYKCDer95S6VVAUVIO4pE.0M8fwcuaNQ4GH6kFNc2Qt.BFjaeAY1OLFAvaBh8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>, benh@kernel.crashing.org
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
Date: Mon, 7 Jul 2008 17:55:39 +1000
User-Agent: KMail/1.9.5
Cc: Zan Lynx <zlynx@acm.org>, Ryan Hope <rmh3093@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com> <486E4FD8.4010102@acm.org> <Pine.LNX.4.64.0807042112130.16912@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807042112130.16912@blonde.site>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8vccI6gu9KN13AU"
Message-Id: <200807071755.40477.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8vccI6gu9KN13AU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 05 July 2008 06:29, Hugh Dickins wrote:

> Fix to 2.6.26-rc8-mm1 x86-implement-pte_special.patch
> Perhaps something similar needed for powerpc?  Nick will know.

Here is the required fix for powerpc-implement-pte_special.patch


--Boundary-00=_8vccI6gu9KN13AU
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="powerpc-implement-pte_special-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="powerpc-implement-pte_special-fix.patch"

Spotted by Hugh:

Stop mprotect's pte_modify from wiping out the powerpc pte_special bit, which
caused oops thereafter when vm_normal_page thought X's abnormal was normal.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/include/asm-powerpc/pgtable-4k.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/pgtable-4k.h
+++ linux-2.6/include/asm-powerpc/pgtable-4k.h
@@ -60,7 +60,7 @@
 /* It should be preserving the high 48 bits and then specifically */
 /* preserving _PAGE_SECONDARY | _PAGE_GROUP_IX */
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY | \
-                         _PAGE_HPTEFLAGS)
+                         _PAGE_SPECIAL | _PAGE_HPTEFLAGS)
 
 /* Bits to mask out from a PMD to get to the PTE page */
 #define PMD_MASKED_BITS		0

--Boundary-00=_8vccI6gu9KN13AU--
