Return-Path: <linux-kernel-owner+w=401wt.eu-S934954AbXFFQQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954AbXFFQQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934403AbXFFQQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:16:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35187 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873AbXFFQQ1 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:16:27 -0400
Date: Wed, 6 Jun 2007 17:16:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070606161621.GA20247@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 09:07:16AM -0700, Jared Hulbert wrote:
> I estimate something on the order 5-10 million Linux phones use
> something similar to these patches.  I wonder if there are that many
> provable users of of the simple cramfs.  This is where the community
> has taken cramfs.

This is what a community disjoint to mainline development has hacked
cramfs in their trees into.  Not a good rationale.  This whole
"but we've always done it" attitute is a little annoying, really.

FYI: Cartsten had an xip fs for s390 aswell, and that evolved into
the filemap.c bits after a lot of rework an quite a few round of
review.

> Nevertheless, I understand your point.  I wrote AXFS in part because
> the hacks required to do XIP on cramfs where ugly, hacky, and complex.

I can't find a reference to AXFS anywhere in this thread.

> > Please
> >use something like the existing ext2 xip mode instead of add support
> >to romfs using the generic filemap methods.
> 
> What??  You mean like use xip_file_mmap() and implement
> get_xip_page()?  Did you read my latest patch?

Yes.  This is the highlevel way to go, just please don't hack it into
cramfs.


