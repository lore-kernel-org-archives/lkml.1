Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXLFGLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXLFGLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 01:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXLFGLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 01:11:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59602 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXLFGLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 01:11:05 -0500
Date: Thu, 06 Dec 2007 15:09:38 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org
In-Reply-To: <47573806.8000808@am.sony.com>
References: <20071205151147.9db4640b.akpm@linux-foundation.org> <47573806.8000808@am.sony.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071206142552.694B.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'll try Milton's suggestion to pre-allocate the memory early.  It seems
> that should work as long as nothing else before the hot-plug mem is added
> needs a large chunk.

Hello. Geoff-san. Sorry for late response.

Could you tell me the value of the following page_size calculation
in vmemmap_populate()? I think this page_size may be too big value. 

------
int __meminit vmemmap_populate(struct page *start_page,
                                       unsigned long nr_pages, int node)
                           :
                           :
        unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
                           :
-------


In addition, I remember that current add_memory() is designed for
only 1 section's addition. (See: memory_probe_store() and
sparse_mem_map_populate().
they require only for 1 section's mem_map by specifing
PAGES_PER_SECTION.)
The 1 section size for normal powerpc box is only 16MB.
(IA64 -> 1GB, x86-64 -> 128MB).

But, if my understanding is correct, PS3's add_memory() requires all
of total memory. I'm afraid something other problems might be hidden
in this issue yet.

(However, I think Milton-san's suggestion is very desirable. 
 If preallocation of hotadd works on ia64 too, I'm very glad.)

Thanks.

-- 
Yasunori Goto 


