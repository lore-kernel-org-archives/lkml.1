Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZFUG0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZFUG0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 02:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZFUG0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 02:26:04 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:53544 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZFUG0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 02:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=drhsokVsblA6Dc81c6ObAmLHnWNuv3j87XvjtvhV4titIFJqZ31yJXTe3edMUVPt2O
         SdmSyWX2zmhmXMtV9AJCJyCIcuk9PgBQuOtVFTjEcSqqot2/QqW8XRi4n/UeqGLQldE5
         Ft2vO+v5m7rX50J9xjLU662IJ5G03U/9NtMtQ=
MIME-Version: 1.0
In-Reply-To: <ac8f92700906202315w7d274a98oa3abe6dcc7f9ede1@mail.gmail.com>
References: <ac8f92700906202315w7d274a98oa3abe6dcc7f9ede1@mail.gmail.com>
Date: Sun, 21 Jun 2009 14:26:04 +0800
Message-ID: <ac8f92700906202326u4de4311bjc77bb81ef93b81f9@mail.gmail.com>
Subject: Fwd: patch for linux-2.6.30/arch/x86_64/mm/init.c
From: jing zhang <zj.barak@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I have no way sending to Andi Kleen, then try Mr. linux-kernel and Mr.
Ingo Molnar.

btw, AC's mailbox @ suse closed, and why?

thank you

---------- Forwarded message ----------
From: jing zhang <zj.barak@gmail.com>
Date: Sun, 21 Jun 2009 14:15:09 +0800
Subject: patch for linux-2.6.30/arch/x86_64/mm/init.c
To: ak@suse.de

Good Sunday Mr. Andi Kleen,

It seems that in function
    unsigned long __init_refok
    init_memory_mapping(unsigned long start, unsigned long end)

CONFIG_DEBUG_PAGEALLOC conflicts with use_pse and use_gbpages when
CONFIG_X86_32 also defined.

The following is my patch to you,

best

look forwar to your opion.
zj

//<<<<<<<<<<<<<<<<<<<<<

#ifdef CONFIG_DEBUG_PAGEALLOC
	/*
	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
	 * This will simplify cpa(), which otherwise needs to support splitting
	 * large pages into small in interrupt context, etc.
	 */
	use_pse = use_gbpages = 0;
#else
	use_pse = cpu_has_pse;
	use_gbpages = direct_gbpages;
#endif

#ifdef CONFIG_X86_32
#ifdef CONFIG_X86_PAE
	set_nx();
	if (nx_enabled)
		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
#endif
	/* Enable PSE if available */
-	if (cpu_has_pse)
+	/* and #ifdef CONFIG_DEBUG_PAGEALLOC */
+	if (cpu_has_pse && use_pse)
		set_in_cr4(X86_CR4_PSE);

	/* Enable PGE if available */
-	if (cpu_has_pge) {
+	/* and #ifdef CONFIG_DEBUG_PAGEALLOC */
+	if (cpu_has_pge && use_gbpages) {
		set_in_cr4(X86_CR4_PGE);
		__supported_pte_mask |= _PAGE_GLOBAL;
	}
#endif /* CONFIG_X86_32 */

//<<<<<<<<<<<<<<<<<<<<<
