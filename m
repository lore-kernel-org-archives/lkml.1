Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYAHWRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYAHWRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYAHWPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:39 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47855
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752138AbYAHWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:34 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 10] xen: mask out PWT too
X-Mercurial-Node: ce684ed89b75370a4cfe9a9443614b685fc38216
Message-Id: <ce684ed89b75370a4cfe.1199829613@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hypervisor doesn't allow PCD or PWT to be set on guest ptes, so
make sure they're masked out.  Also, fix up some previous mispatching.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/xen/mmu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -244,7 +244,7 @@ pte_t xen_make_pte(unsigned long long pt
 	if (pte & 1)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
-	pte &= ~_PAGE_PCD;
+	pte &= ~(_PAGE_PCD | _PAGE_PWT);
 
 	return (pte_t){ .pte = pte };
 }
@@ -293,9 +293,7 @@ pte_t xen_make_pte(unsigned long pte)
 	if (pte & _PAGE_PRESENT)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
-	pte &= ~_PAGE_PCD;
-
-	pte &= ~_PAGE_PCD;
+	pte &= ~(_PAGE_PCD | _PAGE_PWT);
 
 	return (pte_t){ pte };
 }


