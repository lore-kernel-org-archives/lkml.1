Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYAIJRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYAIJRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYAIJQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:16:58 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31832
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbYAIJQ5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:57 -0500
Message-Id: <47849F29.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 09 Jan 2008 09:17:13 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Andi Kleen" <ak@suse.de>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10 of 10] xen: mask out PWT too
References: <patchbomb.1199829603@localhost>
 <ce684ed89b75370a4cfe.1199829613@localhost>
In-Reply-To: <ce684ed89b75370a4cfe.1199829613@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's somewhat ugly, as it will need to be undone/modified for Dom0 and
physical device access support. Jan

>>> Jeremy Fitzhardinge <jeremy@goop.org> 08.01.08 23:00 >>>
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



