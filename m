Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbYCRFbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbYCRFbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYCRFY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:26 -0400
Received: from gw.goop.org ([64.81.55.164]:37858 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbYCRFYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 31] x86: demacro pgalloc paravirt stubs
X-Mercurial-Node: 45a50a088460b556464a584e03ec8fce5d7af65c
Message-Id: <45a50a088460b556464a.1205797026@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn paravirt stubs into inline functions, so that the arguments are
still typechecked.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/pgalloc.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -8,13 +8,14 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define paravirt_alloc_pte(mm, pfn) do { } while (0)
-#define paravirt_alloc_pmd(mm, pfn) do { } while (0)
-#define paravirt_alloc_pmd_clone(pfn, clonepfn, start, count) do { } while (0)
-#define paravirt_alloc_pud(mm, pfn) do { } while (0)
-#define paravirt_release_pte(pfn) do { } while (0)
-#define paravirt_release_pmd(pfn) do { } while (0)
-#define paravirt_release_pud(pfn) do { } while (0)
+static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)	{}
+static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)	{}
+static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
+					    unsigned long start, unsigned long count) {}
+static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)	{}
+static inline void paravirt_release_pte(unsigned long pfn) {}
+static inline void paravirt_release_pmd(unsigned long pfn) {}
+static inline void paravirt_release_pud(unsigned long pfn) {}
 #endif
 
 /*


