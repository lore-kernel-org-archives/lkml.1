Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZCOPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZCOPQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZCOPQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:16:33 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:59718 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZCOPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NzXNMeKJJLu0JP7+Zo8/C1ClywNpECIpX2L20TofYylqQqeKStziQqvCfyD7AjUvDp
         tKgMj+2rkw5hx2jCZK7fH+woKI8TinS/6ZkXApmyoiw0VauAgmtg77ujHR8tLNETLZnm
         2OjbE46tKqj+8FYKXlSLVicg0VfO7M5OzDL18=
Date: Mon, 16 Mar 2009 00:15:18 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -tip 1/2] mm: introduce debug_kmap_atomic
Message-ID: <20090315151517.GA29074@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain> <tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org> <20090314041948.GA3697@localhost.localdomain> <20090314131555.GB17727@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090314131555.GB17727@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 02:15:55PM +0100, Ingo Molnar wrote:
> > The patches are now sitting in -mmotm now. For -tip, here are the rebased
> > patches for the debug_kmap_atomic_prot() check.
> 
> Due to the other-arch changes it's better to keep them in -mm i 
> guess. Once the current batch goes out to linux-next (in the 
> next few days) Andrew could pick up the two -tip patches you 
> posted here.

OK, then please consider to apply this patch for now.

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: remove unnecessary include in iomap_32.c

asm/highmem.h inclusion is added to use kmap_atomic_prot_pfn()
by commit bb6d59ca927d855ffac567b35c0a790c67016103

Now kmap_atomic_prot_pfn is moved to iomap_32.c
by commit dd63fdcc63f0f853b116b52e56200a0e0227cf5f

So the asm/highmem.h inclusion in iomap_32.c is unnecessary now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/mm/iomap_32.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux.tree.git/arch/x86/mm/iomap_32.c
===================================================================
--- linux.tree.git.orig/arch/x86/mm/iomap_32.c
+++ linux.tree.git/arch/x86/mm/iomap_32.c
@@ -18,7 +18,6 @@
 
 #include <asm/iomap.h>
 #include <asm/pat.h>
-#include <asm/highmem.h>
 #include <linux/module.h>
 
 int is_io_mapping_possible(resource_size_t base, unsigned long size)
