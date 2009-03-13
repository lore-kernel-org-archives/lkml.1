Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZCMIRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZCMIRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZCMIM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:26 -0400
Received: from gw.goop.org ([64.81.55.164]:34815 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755506AbZCMIMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/24] xen: add FIX_TEXT_POKE to fixmap
Date: Fri, 13 Mar 2009 01:11:47 -0700
Message-Id: <1236931920-6861-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

FIX_TEXT_POKE[01] are used to map kernel addresses, so they're mapping
pfns, not mfns.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 065fe8d..8969353 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1821,6 +1821,9 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
 #ifdef CONFIG_X86_LOCAL_APIC
 	case FIX_APIC_BASE:	/* maps dummy local APIC */
 #endif
+	case FIX_TEXT_POKE0:
+	case FIX_TEXT_POKE1:
+		/* All local page mappings */
 		pte = pfn_pte(phys, prot);
 		break;
 
-- 
1.6.0.6

