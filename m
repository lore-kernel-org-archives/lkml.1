Return-Path: <linux-kernel-owner+w=401wt.eu-S1030282AbXFHIB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030282AbXFHIB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938485AbXFHH0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:26:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35624 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938402AbXFHH0U (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:26:20 -0400
Date: Fri, 8 Jun 2007 08:26:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: carsteno@de.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608072609.GA13115@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	carsteno@de.ibm.com, Jared Hulbert <jaredeh@gmail.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com> <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4669027E.3070406@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 09:17:18AM +0200, Carsten Otte wrote:
> Christoph Hellwig wrote:
> >On Thu, Jun 07, 2007 at 07:07:54PM +0200, Carsten Otte wrote:
> >>I've had a few beer long discussion with Joern Engel and David 
> >>Woodhouse on this one. To cut a long discussion short: the current XIP 
> >>infrastructure is not sufficient to be used on top of mtd. We'd need 
> >>some extenstions:
> >>- on get_xip_page() we'd need to state if we want the reference 
> >>read-only or read+write
> >>- we need a put_xip_page() to return references
> >>- and finally we need a callback for the referece, so that the mtd 
> >>driver can ask to get its reference back (in order to unmap from 
> >>userland when erasing a block)
> >
> >And we'll need that even when using cramfs.  There's not way we'd
> >merge a hack where the user has to specify a physical address on
> >the mount command line.
> Nay, the proposed solution is read only. From what I understood of the 
> discussion, it does'nt need that. The entire flash memory can be read 
> at the same time. Things start to get interresting when you want to 
> write, then you need to care about erase blocks and such.

We can have a simpler variant as a start if we really want.  But we
need to pass it through the mtd layer.  There is a reason we have this
thing called devices drivers, and we don't want to add knowledge of
ioremap to the filesystems and have users find out physical addresses
of their flash to pass it as mount option.
