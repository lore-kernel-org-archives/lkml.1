Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYIYMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYIYMXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYIYMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:23:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56122 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYIYMXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:23:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <20080924154120.GA10837@csn.ul.ie>
References: <20080924210309.8C3B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080924154120.GA10837@csn.ul.ie>
Message-Id: <20080925212025.58A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Sep 2008 21:23:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 1) in normal page, show PAZE_SIZE
> > 
> > because, any userland application woks as pagesize==PAZE_SIZE 
> > on current powerpc architecture.
> > 
> > because
> > 
> > fs/binfmt_elf.c
> > ------------------------------
> > static int
> > create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
> >                 unsigned long load_addr, unsigned long interp_load_addr)
> > {
> > (snip)
> >         NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
> >         NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE); /* pass ELF_EXEC_PAGESIZE to libc */
> > 
> > include/asm-powerpc/elf.h
> > -----------------------------
> > #define ELF_EXEC_PAGESIZE       PAGE_SIZE 
> > 
> 
> I'm ok with this option and dropping the MMUPageSize patch as the user
> should already be able to identify that the hardware does not support 64K
> base pagesizes. I will leave the name as KernelPageSize so that it is still
> difficult to confuse it with MMU page size.
> 
> > 
> > 2) in normal page, no display any page size.
> >    only hugepage case, display page size.
> > 
> > because, An administrator want to hugepage size only. (AFAICS)
> > 
> 
> I prefer option 1 as it's easier to parse the presense of information
> than infer from the absense of it.

OK.

I'll review and test your latest patch without MMUPageSize part.
(maybe today's midnight or tommorow)

Thanks!



