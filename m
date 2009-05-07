Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbZEHAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbZEHAbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbZEHAKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:51 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52703
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589AbZEHAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:00 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/16] x86: make /dev/mem mappings _PAGE_IOMAP
Date: Thu,  7 May 2009 14:10:50 -0700
Message-Id: <1241730653-4688-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730653-4688-1-git-send-email-jeremy@goop.org>
References: <1241730653-4688-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: allow hardware to be mapped via /dev/mem

Use _PAGE_IOMAP on /dev/mem mappings.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 4d2a4df..56899ae 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -504,7 +504,7 @@ int free_memtype(u64 start, u64 end)
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
-	return vma_prot;
+	return __pgprot(pgprot_val(vma_prot) | _PAGE_IOMAP);
 }
 
 #ifdef CONFIG_STRICT_DEVMEM
-- 
1.6.0.6

