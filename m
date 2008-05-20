Return-Path: <linux-kernel-owner+w=401wt.eu-S1764779AbYETJJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764779AbYETJJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbYETJG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:06:58 -0400
Received: from gw.goop.org ([64.81.55.164]:44084 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762191AbYETJG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:06:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 8 of 8] xen: use PTE_MASK in pte_mfn()
X-Mercurial-Node: 97f60002c43b392c5e452a67b7cec01320a653cd
Message-Id: <97f60002c43b392c5e45.1211268384@localhost>
In-Reply-To: <patchbomb.1211268376@localhost>
Date: Tue, 20 May 2008 08:26:24 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PTE_MASK to extract mfn from pte.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/xen/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -127,7 +127,7 @@
 
 static inline unsigned long pte_mfn(pte_t pte)
 {
-	return (pte.pte & ~_PAGE_NX) >> PAGE_SHIFT;
+	return (pte.pte & PTE_MASK) >> PAGE_SHIFT;
 }
 
 static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)


