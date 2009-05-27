Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbZE0HTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbZE0HTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbZE0HRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:22 -0400
Received: from claw.goop.org ([74.207.240.146]:41462 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109AbZE0HRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:21 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/16] x86: make /dev/mem mappings _PAGE_IOMAP
Date: Wed, 27 May 2009 00:15:35 -0700
Message-Id: <1243408538-21100-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243408538-21100-1-git-send-email-jeremy@goop.org>
References: <1243408538-21100-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use _PAGE_IOMAP on /dev/mem mappings.

[ Impact: allow hardware to be mapped via /dev/mem in Xen ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 5ba8d88..3f7886f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -494,7 +494,7 @@ int free_memtype(u64 start, u64 end)
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
-	return vma_prot;
+	return __pgprot(pgprot_val(vma_prot) | _PAGE_IOMAP);
 }
 
 #ifdef CONFIG_STRICT_DEVMEM
-- 
1.6.0.6

