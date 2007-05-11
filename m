Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbXEKHlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbXEKHlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXEKHkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:40:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbXEKHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:40:55 -0400
Date: Fri, 11 May 2007 08:40:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/5] lguest guest feedback tidyups
Message-ID: <20070511074050.GB25727@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>
References: <1178846246.23513.21.camel@localhost.localdomain> <1178846354.23513.23.camel@localhost.localdomain> <1178846490.23513.27.camel@localhost.localdomain> <20070511065613.GB25182@infradead.org> <1178868666.23513.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178868666.23513.49.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 05:31:06PM +1000, Rusty Russell wrote:
> 	Well, without ioremap, the memory wouldn't normally be mapped.  Is
> there something better to use?

Either use accessors or use your own lguest-specific remapping function that
doesn't return __iomem function

> > So instead of sprinkling cast
> > around add lguest_read*/lguest_write* accessors that do the __force cast
> > once and make sure the ioremap return value is always accessed using those.
> 
> And that's nothing to do with iremap.  They're required because guest
> "physical" == host virtual, and casting a long to a "__user void *"
> seems to require a __force.

Well, it's the same problem really.  You want to treat it as host virtual
in some places and and guest physical in others, but you need to keep
the abstraction clean.  To keep that absraction clean you introduce
accessors that contain the __force cast.  Now that you have these accessors
instead of random casts you need to think a bit where the host virtual
abstraction makes more sense and were the the guest virtual abstraction
makes more sense and use it consistantly there with as few as possible
uses of the accessors in between. 

Now to something different than the technical content of this mail:

> Hi Christoph!

> I enjoy a good Hellwigging as much as anyone, but your aim is off.

Please stop this crap.  I know who I am, so there's no need to waste
mail estate with saying Hi.  Also please stop being a total fuckass
and abusing my lastname just because you didn't get what was in the
mail.
