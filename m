Return-Path: <linux-kernel-owner+w=401wt.eu-S965642AbXBGF4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965642AbXBGF4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965643AbXBGF4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:56:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3337 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965642AbXBGF4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:56:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=i/vW3xQ7cRnn2LOkaCE5mJ49i1ArBVCk2Q3AZ3B00h5kmb2UVKNF7tTjrrGY2QTwa
	5s8MX0o50xX8+KwlIw1qw==
Date: Tue, 6 Feb 2007 21:56:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] smaps: add pages referenced count to smaps
In-Reply-To: <20070206214414.96b0336b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702062154530.9073@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062121160.8623@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702062122540.8623@chino.kir.corp.google.com>
 <20070206214414.96b0336b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Andrew Morton wrote:

> > @@ -190,18 +191,20 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
> >  
> >  	if (mss)
> >  		seq_printf(m,
> > -			   "Size:          %8lu kB\n"
> > -			   "Rss:           %8lu kB\n"
> > -			   "Shared_Clean:  %8lu kB\n"
> > -			   "Shared_Dirty:  %8lu kB\n"
> > -			   "Private_Clean: %8lu kB\n"
> > -			   "Private_Dirty: %8lu kB\n",
> > +			   "Size:           %8lu kB\n"
> > +			   "Rss:            %8lu kB\n"
> > +			   "Shared_Clean:   %8lu kB\n"
> > +			   "Shared_Dirty:   %8lu kB\n"
> > +			   "Private_Clean:  %8lu kB\n"
> > +			   "Private_Dirty:  %8lu kB\n"
> > +			   "Pgs_Referenced: %8li\n",
> 
> I guess we might as well make this %8lu kB as well?
> 

Ah, %8lu would work since it's a count of pages and not a size.

> This is testing the software-referenced bit.  We want to be counting the
> pte-referenced bits (pte_young).
> 
> Hence poking clear_refs should run pte_mkold().
> 
> Perhaps we should also be running ClearPageReferenced and counting pages
> which are pte_young()||PageReferenced.
> 

Ok.
