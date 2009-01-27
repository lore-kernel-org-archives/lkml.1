Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZA0GfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZA0GfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 01:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZA0GfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 01:35:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZA0GfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 01:35:04 -0500
Date: Mon, 26 Jan 2009 22:33:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: get_nid_for_pfn() returns int
Message-Id: <20090126223350.610b0283.akpm@linux-foundation.org>
In-Reply-To: <20090119175919.GA7476@us.ibm.com>
References: <4973AEEC.70504@gmail.com>
	<20090119175919.GA7476@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 09:59:19 -0800 Gary Hade <garyhade@us.ibm.com> wrote:

> On Sun, Jan 18, 2009 at 11:36:28PM +0100, Roel Kluin wrote:
> > get_nid_for_pfn() returns int
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > vi drivers/base/node.c +256
> > static int get_nid_for_pfn(unsigned long pfn)
> > 
> > diff --git a/drivers/base/node.c b/drivers/base/node.c
> > index 43fa90b..f8f578a 100644
> > --- a/drivers/base/node.c
> > +++ b/drivers/base/node.c
> > @@ -303,7 +303,7 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
> >  	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
> >  	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
> >  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
> > -		unsigned int nid;
> > +		int nid;
> > 
> >  		nid = get_nid_for_pfn(pfn);
> >  		if (nid < 0)
> 
> My mistake.  Good catch.
> 

Presumably the (nid < 0) case has never happened.

Should we retain the test?

Is silently skipping the node in that case desirable behaviour?
