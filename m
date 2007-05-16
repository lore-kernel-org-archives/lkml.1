Return-Path: <linux-kernel-owner+w=401wt.eu-S1762460AbXEPHAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762460AbXEPHAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXEPHA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:00:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57606 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbXEPHAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:00:24 -0400
Date: Wed, 16 May 2007 08:00:15 +0100
From: hch <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, hch <hch@infradead.org>
Subject: Re: [PATCH 1/6] lguest: host code tidyups
Message-ID: <20070516070015.GA13980@infradead.org>
Mail-Followup-To: hch <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <1179191827.10836.24.camel@localhost.localdomain> <20070515214235.b0625699.sfr@canb.auug.org.au> <20070515214756.b8020d4e.sfr@canb.auug.org.au> <1179271936.23574.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179271936.23574.2.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 09:32:16AM +1000, Rusty Russell wrote:
> On Tue, 2007-05-15 at 21:47 +1000, Stephen Rothwell wrote:
> > On Tue, 15 May 2007 21:42:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > On Tue, 15 May 2007 11:17:07 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > -		on_each_cpu(adjust_pge, 0, 0, 1);
> > > > +		on_each_cpu(adjust_pge, (void *)0, 0, 1);
> > >
> > > Sorry?  What ever happened to a simple NULL?
> > 
> > Oh, I guess that is an explicit (numeric) 0 (of some type) caste to
> > "void *" because of the prototype - rather than not passing anything?
> 
> Indeed.  We really want to pass a bool, but on_each_cpu uses a void *.
> Hence the clearest solution seemed "(void *)0" and "(void *)1" in the
> callers.

Cleanest way to do that is to pass the value by reference.

	const int some_useful_name = 0;

	 on_each_cpu(adjust_pge, &some_useful_name, 0, 1);
