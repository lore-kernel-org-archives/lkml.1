Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbYGHXbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbYGHXbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbYGHXPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:24 -0400
Received: from gw.goop.org ([64.81.55.164]:51224 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 32 of 55] xen: fix truncation of machine address
X-Mercurial-Node: 2292baf6aa87e3288bcf2fa22d5e2d11b4ef800e
Message-Id: <2292baf6aa87e3288bcf.1215554814@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arbitrary_virt_to_machine can truncate a machine address if its above
4G.  Cast the problem away.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -186,7 +186,7 @@
 
 	BUG_ON(pte == NULL);
 
-	return XMADDR((pte_mfn(*pte) << PAGE_SHIFT) + offset);
+	return XMADDR(((phys_addr_t)pte_mfn(*pte) << PAGE_SHIFT) + offset);
 }
 
 void make_lowmem_page_readonly(void *vaddr)


