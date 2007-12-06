Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXLFKuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXLFKuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXLFKt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:49:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44617 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXLFKt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:49:56 -0500
Date: Thu, 06 Dec 2007 19:48:11 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
Cc: Geoff Levand <geoffrey.levand@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0712061055140.6524@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0712061052390.6524@pademelon.sonytel.be> <Pine.LNX.4.62.0712061055140.6524@pademelon.sonytel.be>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071206191717.6955.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 6 Dec 2007, Geert Uytterhoeven wrote:
> > On Thu, 6 Dec 2007, Yasunori Goto wrote:
> > > > I'll try Milton's suggestion to pre-allocate the memory early.  It seems
> > > > that should work as long as nothing else before the hot-plug mem is added
> > > > needs a large chunk.
> > > 
> > > Hello. Geoff-san. Sorry for late response.
> > > 
> > > Could you tell me the value of the following page_size calculation
> > > in vmemmap_populate()? I think this page_size may be too big value. 
> > > 
> > > ------
> > > int __meminit vmemmap_populate(struct page *start_page,
> > >                                        unsigned long nr_pages, int node)
> > >                            :
> > >                            :
> > >         unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
> > >                            :
> > > -------
> > 
> > 24 MiB
> 
> Bummer, messing up bits and MiB.
> 
> 16 MiB of course.

16 MiB is not page size. It is "section size". 
IIRC, powerpc's page size must be 4K (or 64K).
If page size is 4k, vmemmap_alloc_block will call the order 12 page.

Is it really correct value for vmemmap population?

> PS3 initially starts with 128 MiB.
> Later hotplug is used to add the remaining memory (96 or 112 MIB, IIRC).

Ok.
Then, add_memory() must be called 6 or 7 times for each sections.

Thanks.


-- 
Yasunori Goto 


