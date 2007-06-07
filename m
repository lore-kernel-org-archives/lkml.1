Return-Path: <linux-kernel-owner+w=401wt.eu-S936938AbXFGVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936938AbXFGVPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936951AbXFGVP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:15:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45446 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935743AbXFGVP1 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:15:27 -0400
Date: Thu, 7 Jun 2007 22:15:19 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070607211519.GA22348@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com> <20070606161621.GA20247@infradead.org> <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com> <20070607193707.GA17144@infradead.org> <6934efce0706071411y6d184629i5ce0694175bef164@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706071411y6d184629i5ce0694175bef164@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 02:11:44PM -0700, Jared Hulbert wrote:
> >that even more important doesn't require pulling in
> >the whole block layer which is especially important for embedded
> >devices at the lower end of the scala.
> 
> Good point.  That is a big oversight.  Though I would prefer to handle
> that in the same fs rather than fork.

If if were actually talking about complex filesystem I'd agree.  But
the cramfs xip patch posted here touches about 2/3 of the number of
lines that cramfs has in total.  And cramfs is not exactly the best
base to start with..

> >I still think it'd be even better to just
> >hook xip support into jffs or logfs because they give you a full
> >featured flash filesystem for all needs without the complexity
> >of strictly partitioning between xip-capable and write parts
> >of your storage.
> 
> This is nirvana.   But it is not the goal of the patches in question.
> In fact there are several use cases that don't need and don't value
> the writeability and don't need therefore the overhead.  It is a long
> term goal never the less.

With the filemap_xip.c helpers adding xip support to any filesystem
is pretty trivial for the highlevel filesystem operations.  The only
interesting bit is the lowlevel code (the get_xip_page method and
the others Carsten mentioned), but we need to do these lowlevel
code in a generic and proper way anyway.

I'll try to hack up an xip prototype for jffs2 next week.
