Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYHUAJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYHUAJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYHUAJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:09:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:59193 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYHUAJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iQaiY+/SgLLpzdKR5Xjfynpk7Rc+b/oYwrQS+wjLBjSuMcMnU+ZZ31zfL2qvCzF034
         kDselvy9ZFxUtd9zVgP8zIt6okgncZp3htKIijGEC/ZS5/LNwCNwNDwGbL9wMixzhoaE
         28VWtAcRba8pqa1g0G/eGgxzRmt2fT4tc/+y0=
Date: Thu, 21 Aug 2008 02:08:48 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Sean MacLennan <smaclennan@pikatech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Section mismatch contig_page_data and bootmem_node_data
Message-ID: <20080821000844.GA10031@joi>
References: <20080820135551.74911cb3@lappy.seanm.ca> <20080820190436.GA5388@joi> <20080820151531.38fc1071@lappy.seanm.ca> <87myj74azn.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87myj74azn.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 11:45:00PM +0200, Johannes Weiner wrote:
> Hi,
> 
> > On Wed, 20 Aug 2008 21:05:41 +0200
> > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> >
> >> I thought about this warning today and found 2 other solutions:
> >> 1) Mark contig_page_data as __ref (but it might hide real bugs).
> >> 2) Remove bdata from struct pglist_data and access it directly through
> >>    bootmem_node_data. It requires passing node number to all functions
> >>    which use bdata, but unfortunately arch/ia64/mm/discontig.c handles
> >>    node numbering its own way. I'm still investigating it.
> 
> Yeah, I gave it a shot once too but dropped it again after I looked at
> ia64 code.
> 
> Perhaps we can just remove the static assignment and do it at boot up?

That won't work - modpost will warn at different place about section
mismatch. But even if it would work, we lose potentially useful
analysis of all uses of pglist_data->bdata.

But I think I found better solution - replace "struct bootmem_data *bdata"
in struct pglist_data with "int bootmem_node;" and change all uses of bdata
to &bootmem_node_data[struct pglist_data *->bootmem_node].

What do you think about it? Would it be acceptable?

PS: restored cc'ing LKML

Marcin
