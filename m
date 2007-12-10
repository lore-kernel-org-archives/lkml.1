Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbXLJB5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbXLJB5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 20:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXLJB4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 20:56:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39895 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXLJB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 20:56:54 -0500
Date: Mon, 10 Dec 2007 10:55:00 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Andrew Morton <akpm@linux-foundation.org>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org
In-Reply-To: <475A05A8.2050909@am.sony.com>
References: <20071206191717.6955.Y-GOTO@jp.fujitsu.com> <475A05A8.2050909@am.sony.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071210104948.B6E8.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yasunori Goto wrote:
> >> On Thu, 6 Dec 2007, Geert Uytterhoeven wrote:
> >> > On Thu, 6 Dec 2007, Yasunori Goto wrote:
> >> > > > I'll try Milton's suggestion to pre-allocate the memory early.  It seems
> >> > > > that should work as long as nothing else before the hot-plug mem is added
> >> > > > needs a large chunk.
> >> > > 
> >> > > Hello. Geoff-san. Sorry for late response.
> >> > > 
> >> > > Could you tell me the value of the following page_size calculation
> >> > > in vmemmap_populate()? I think this page_size may be too big value. 
> >> > > 
> >> > > ------
> >> > > int __meminit vmemmap_populate(struct page *start_page,
> >> > >                                        unsigned long nr_pages, int node)
> >> > >                            :
> >> > >                            :
> >> > >         unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
> >> > >                            :
> >> > > -------
> >> 
> >> 16 MiB of course.
> > 
> > 16 MiB is not page size. It is "section size". 
> > IIRC, powerpc's page size must be 4K (or 64K).
> > If page size is 4k, vmemmap_alloc_block will call the order 12 page.
> 
> 
> By default PS3 uses 4K virtual pages, and 16M linear pages.
> 
> 
> > Is it really correct value for vmemmap population?
> 
> 
> It seems vmemmap needs linear pages, so I think it is ok.

Oh, I see. Sorry for noise.

Bye.

-- 
Yasunori Goto 


