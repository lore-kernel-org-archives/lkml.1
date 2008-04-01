Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYDAW60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYDAW60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYDAW6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:58:18 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41109 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbYDAW6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:58:17 -0400
Date: Wed, 2 Apr 2008 01:58:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: wli@holomorphy.com, lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: HugeTLB vs. SH3 cpu
Message-ID: <20080401225809.GC32269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/Kconfig says:

config HUGETLBFS
        bool "HugeTLB file system support"
        depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN


arch/sh/mm/Kconfig says:

choice
        prompt "HugeTLB page size"
        depends on HUGETLB_PAGE && (CPU_SH4 || CPU_SH5) && MMU


The compiler says with CONFIG_CPU_SH3:

<--  snip  -->

...
  CC      arch/sh/mm/hugetlbpage.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/hugetlbpage.c:14:/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/hugetlb.h: In function 'prepare_hugepage_range':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/hugetlb.h:73: error: 'HPAGE_SHIFT' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/hugetlb.h:73: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/hugetlb.h:73: error: for each function it appears in.)
make[2]: *** [arch/sh/mm/hugetlbpage.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

