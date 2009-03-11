Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZCKOfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZCKOfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZCKOfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:35:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:38374 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbZCKOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YH1KJIfkkCSeCJIphw5ztMcrGSWLEPeVOXVEmPZrvmkUZKSqyKTsAoalJq+NbXx6IP
         iDuAtl5Qa/gc8oMT+Mq6TNW8ioFd1vW7T/zgv3sas4oHq501ceEbpaR8kktkQgttKDdv
         7wszruh4MAkZMCNNqKHtH6z+FiV3/JXB0WMjM=
Date: Wed, 11 Mar 2009 23:34:50 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 2/2] x86: debug check for kmap_atomic_pfn and
	iomap_atomic_prot_pfn()
Message-ID: <20090311143449.GB22244@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090311143317.GA22244@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may be useful for kmap_atomic_pfn() and iomap_atomic_prot_pfn() to
check invalid kmap usage as well as kmap_atomic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
---
 arch/x86/mm/highmem_32.c |    2 ++
 1 file changed, 2 insertions(+)

Index: 2.6-mmotm/arch/x86/mm/highmem_32.c
===================================================================
--- 2.6-mmotm.orig/arch/x86/mm/highmem_32.c
+++ 2.6-mmotm/arch/x86/mm/highmem_32.c
@@ -128,6 +128,8 @@ void *kmap_atomic_prot_pfn(unsigned long
 
 	pagefault_disable();
 
+	debug_kmap_atomic_prot(type);
+
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
