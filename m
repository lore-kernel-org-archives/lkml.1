Return-Path: <linux-kernel-owner+w=401wt.eu-S965633AbXFGTjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965633AbXFGTjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935064AbXFGTix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:38:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51782 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbXFGTiv (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:38:51 -0400
Date: Thu, 7 Jun 2007 20:38:44 +0100
From: Christoph Hellwig <hch@infradead.org>
To: carsteno@de.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070607193844.GB17144@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	carsteno@de.ibm.com, Jared Hulbert <jaredeh@gmail.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46683B6A.6030306@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 07:07:54PM +0200, Carsten Otte wrote:
> I've had a few beer long discussion with Joern Engel and David 
> Woodhouse on this one. To cut a long discussion short: the current XIP 
> infrastructure is not sufficient to be used on top of mtd. We'd need 
> some extenstions:
> - on get_xip_page() we'd need to state if we want the reference 
> read-only or read+write
> - we need a put_xip_page() to return references
> - and finally we need a callback for the referece, so that the mtd 
> driver can ask to get its reference back (in order to unmap from 
> userland when erasing a block)

And we'll need that even when using cramfs.  There's not way we'd
merge a hack where the user has to specify a physical address on
the mount command line.

> While I fully agree, that a flash filesystem using xip would be very 
> desireable, the proposed cramfs extension is a totaly different beast 
> that has its own value to me: the ability to select per file whether 
> xip or compression is more efficient.

You'd of course want all that for a full flash filesystem aswell.
