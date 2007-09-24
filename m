Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbXIXLnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbXIXLnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbXIXLn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:43:27 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:38288 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbXIXLn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:43:26 -0400
Message-ID: <46F7A2BA.6070406@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 17:12:50 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails with 

  CC      arch/ia64/kernel/efi.o
arch/ia64/kernel/efi.c: In function 'efi_memmap_init':
arch/ia64/kernel/efi.c:1088: error: 'total_memory' undeclared (first use in this function)
arch/ia64/kernel/efi.c:1088: error: (Each undeclared identifier is reported only once
arch/ia64/kernel/efi.c:1088: error: for each function it appears in.)
make[1]: *** [arch/ia64/kernel/efi.o] Error 1
make: *** [arch/ia64/kernel] Error 2

The use-extended-crashkernel-command-line-on-ia64.patch uses total_mem and 
return total_memory.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
--- linux-2.6.23-rc7/arch/ia64/kernel/efi.c     2007-09-24 15:28:06.000000000 +0530
+++ linux-2.6.23-rc7/arch/ia64/kernel/~efi.c    2007-09-24 16:56:03.000000000 +0530
@@ -1085,7 +1085,7 @@ efi_memmap_init(unsigned long *s, unsign
        *s = (u64)kern_memmap;
        *e = (u64)++k;
 
-       return total_memory;
+       return total_mem;
 }
 
 void

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
