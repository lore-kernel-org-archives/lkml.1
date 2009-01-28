Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZA1FEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZA1FEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZA1FEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:04:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46354 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZA1FEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:04:34 -0500
Date: Wed, 28 Jan 2009 14:04:24 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: get_nid_for_pfn() returns int
Cc: Roel Kluin <roel.kluin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Gary Hade <garyhade@us.ibm.com>
In-Reply-To: <20090127210727.GA9592@us.ibm.com>
References: <20090126223350.610b0283.akpm@linux-foundation.org> <20090127210727.GA9592@us.ibm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090128135408.DC38.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jan 26, 2009 at 10:33:50PM -0800, Andrew Morton wrote:
> > On Mon, 19 Jan 2009 09:59:19 -0800 Gary Hade <garyhade@us.ibm.com> wrote:
> > 
> > > On Sun, Jan 18, 2009 at 11:36:28PM +0100, Roel Kluin wrote:
> > > > get_nid_for_pfn() returns int
> > > > 
> > > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > > ---
> > > > vi drivers/base/node.c +256
> > > > static int get_nid_for_pfn(unsigned long pfn)
> > > > 
> > > > diff --git a/drivers/base/node.c b/drivers/base/node.c
> > > > index 43fa90b..f8f578a 100644
> > > > --- a/drivers/base/node.c
> > > > +++ b/drivers/base/node.c
> > > > @@ -303,7 +303,7 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
> > > >  	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
> > > >  	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
> > > >  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
> > > > -		unsigned int nid;
> > > > +		int nid;
> > > > 
> > > >  		nid = get_nid_for_pfn(pfn);
> > > >  		if (nid < 0)
> > > 
> > > My mistake.  Good catch.
> > > 
> > 
> > Presumably the (nid < 0) case has never happened.
> 
> We do know that it is happening on one system while creating
> a symlink for a memory section so it should also happen on
> the same system if unregister_mem_sect_under_nodes() were
> called to remove the same symlink.
> 
> The test was actually added in response to a problem with an
> earlier version reported by Yasunori Goto where one or more
> of the leading pages of a memory section on the 2nd node of
> one of his systems was uninitialized because I believe they
> coincided with a memory hole. 

Yes. There are some memory hole pages which are occupied by firmware in
our box.

-- 
Yasunori Goto 


