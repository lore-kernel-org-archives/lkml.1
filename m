Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZCKQzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZCKQzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZCKQzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:55:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:44878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZCKQzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:55:15 -0400
Date: Wed, 11 Mar 2009 16:54:35 GMT
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090311143449.GB22244@localhost.localdomain>
References: <20090311143449.GB22244@localhost.localdomain>
Subject: [tip:x86/mm] x86: debug check for kmap_atomic_pfn and iomap_atomic_prot_pfn()
Message-ID: <tip-12074fa1073013dd11f1cff41db018d5cff4ecd9@git.kernel.org>
Git-Commit-ID: 12074fa1073013dd11f1cff41db018d5cff4ecd9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 16:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12074fa1073013dd11f1cff41db018d5cff4ecd9
Gitweb:     http://git.kernel.org/tip/12074fa1073013dd11f1cff41db018d5cff4ecd9
Author:     "Akinobu Mita" <akinobu.mita@gmail.com>
AuthorDate: Wed, 11 Mar 2009 23:34:50 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Mar 2009 15:47:46 +0100

x86: debug check for kmap_atomic_pfn and iomap_atomic_prot_pfn()

It may be useful for kmap_atomic_pfn() and iomap_atomic_prot_pfn()
to check invalid kmap usage as well as kmap_atomic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090311143449.GB22244@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/highmem_32.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index ae4c8da..f256e73 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -128,6 +128,8 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 
 	pagefault_disable();
 
+	debug_kmap_atomic_prot(type);
+
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
