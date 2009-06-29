Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZF2DIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZF2DIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZF2DI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:08:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:39498 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZF2DI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aUWdseGarIeYtiavxmeAY2ZNy5hkp9IypPUi/LDWb9LJONHXLt2Zl4HCyJf7p6N9YR
         ZpYWAhXNvxsW9sBTHhvaaIVqPRRvCKV5YZIdBx6QGLkoW3btqGTXB3SGdPXXBE1172+g
         o2krMYiQAphTlQuDmu55KRrc+jG76216ZHHUA=
Subject: [PATCH]highmem_32.c: add argument pointer checking
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 11:08:26 +0800
Message-Id: <1246244906.5759.5.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It had better add argument pointer checking.

If any guys write driver want to alloc hightmem and pass a no-initial pointer,
it would be crashed.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
arch/x86/mm/highmem_32.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 58f621e..e52e1a9 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -31,6 +31,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
+	BUG_ON(!page);
 
 	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
 	pagefault_disable();
@@ -58,6 +59,9 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
 
+	if(!kvaddr)
+		return;
+
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
 	 * without first remap it.  Keeping stale mappings around is a bad idea


