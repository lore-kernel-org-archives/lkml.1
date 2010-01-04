Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0AEBMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0AEBMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032Ab0AEBMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:12:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:60582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab0AEBMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:12:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229176893"
Date: Mon, 4 Jan 2010 20:16:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH v3] readahead: introduce O_RANDOM for
	POSIX_FADV_RANDOM
Message-ID: <20100104121642.GA12266@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <28c262361001032120v284e92b5ub1211f3d1fca6140@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262361001032120v284e92b5ub1211f3d1fca6140@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Mon, Jan 04, 2010 at 01:20:49PM +0800, Minchan Kim wrote:
> > --- linux.orig/mm/readahead.c   2010-01-04 12:39:29.000000000 +0800
> > +++ linux/mm/readahead.c        2010-01-04 12:39:30.000000000 +0800
> > @@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
> >        if (!ra->ra_pages)
> >                return;
> >
> > +       /* be dumb */
> > +       if (filp->f_flags & O_RANDOM) {
> > +               force_page_cache_readahead(mapping, filp, offset, req_size);
> > +               return;
> > +       }
> > +
> 
> Let me have a dumb question. :)
> 
> How about testing O_RANDOM in front of ra_pages testing?
> 
> My intention is that although we turn off ra, it would be better to read
> contiguous block all at once than readpage() callback doing I/O
> one page at a time.
> 
> Is it break some semantics or happen some problem in ondemand readahead?

Yes it will have some problem with shrink_readahead_size_eio(), which
want to disable readahead and use ->readpage() when ra_pages==0.

Do you have specific use case in mind? The file systems that set
ra_pages=0 seems to don't need readahead, too. 

Thanks,
Fengguang
