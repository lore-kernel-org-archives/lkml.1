Return-Path: <linux-kernel-owner+w=401wt.eu-S965647AbXBGGGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647AbXBGGGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXBGGGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:06:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965647AbXBGGGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:06:44 -0500
Date: Tue, 6 Feb 2007 22:06:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] smaps: add pages referenced count to smaps
Message-Id: <20070206220632.31c6dd9e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702062154530.9073@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062121160.8623@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0702062122540.8623@chino.kir.corp.google.com>
	<20070206214414.96b0336b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702062154530.9073@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 21:56:23 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> On Tue, 6 Feb 2007, Andrew Morton wrote:
> 
> > > @@ -190,18 +191,20 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
> > >  
> > >  	if (mss)
> > >  		seq_printf(m,
> > > -			   "Size:          %8lu kB\n"
> > > -			   "Rss:           %8lu kB\n"
> > > -			   "Shared_Clean:  %8lu kB\n"
> > > -			   "Shared_Dirty:  %8lu kB\n"
> > > -			   "Private_Clean: %8lu kB\n"
> > > -			   "Private_Dirty: %8lu kB\n",
> > > +			   "Size:           %8lu kB\n"
> > > +			   "Rss:            %8lu kB\n"
> > > +			   "Shared_Clean:   %8lu kB\n"
> > > +			   "Shared_Dirty:   %8lu kB\n"
> > > +			   "Private_Clean:  %8lu kB\n"
> > > +			   "Private_Dirty:  %8lu kB\n"
> > > +			   "Pgs_Referenced: %8li\n",
> > 
> > I guess we might as well make this %8lu kB as well?
> > 
> 
> Ah, %8lu would work since it's a count of pages and not a size.

All the other fields in there are using kbytes.  We might as well be
consistent.

Plus if we express the quantity in bytes, userspace doesn't need to know
what the pagesize is.  If we were to express it in pages, an app on a 64k
pagesize kernel will show very different numbers from the same app on a 4k
pagesize kernel.

