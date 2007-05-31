Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbXEaVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbXEaVlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXEaVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:41:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbXEaVlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:41:11 -0400
To: Zach Brown <zach.brown@oracle.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 2/4] CONFIG_STABLE: Switch off kmalloc(0) tests in slab allocators
References: <20070531002047.702473071@sgi.com>
	<20070531003012.532539202@sgi.com>
	<20070531195133.GK5488@mami.zabbo.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Jun 2007 00:37:48 +0200
In-Reply-To: <20070531195133.GK5488@mami.zabbo.net>
Message-ID: <p736468d3gj.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zach.brown@oracle.com> writes:

> > +#ifndef CONFIG_STABLE
> >  	/*
> >  	 * We should return 0 if size == 0 (which would result in the
> >  	 * kmalloc caller to get NULL) but we use the smallest object
> > @@ -81,6 +82,7 @@ static inline int kmalloc_index(size_t s
> >  	 * we can discover locations where we do 0 sized allocations.
> >  	 */
> >  	WARN_ON_ONCE(size == 0);
> > +#endif
> 
> > +#ifndef CONFIG_STABLE
> >  	WARN_ON_ONCE(size == 0);
> > +#endif
> 
> I wonder if there wouldn't be value in making a WARN_*() variant that
> contained the ifdef internally so we could lose these tedious
> surrounding ifdefs in call sites.  WARN_DEVELOPER_WHEN(), or something.
> I don't care what it's called.  

Networking has had NETDEBUG(codeblock) for this. Perhaps something
similar would be useful (DEVELOPMENT(codeblock)) in addition
to the special WARN/BUG_ONs

-Andi
