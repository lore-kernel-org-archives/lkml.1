Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbXEOXcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbXEOXcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbXEOXcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:32:46 -0400
Received: from ozlabs.org ([203.10.76.45]:57851 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbXEOXcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:32:46 -0400
Subject: Re: [PATCH 1/6] lguest: host code tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, hch <hch@infradead.org>
In-Reply-To: <20070515214756.b8020d4e.sfr@canb.auug.org.au>
References: <1179191827.10836.24.camel@localhost.localdomain>
	 <20070515214235.b0625699.sfr@canb.auug.org.au>
	 <20070515214756.b8020d4e.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 16 May 2007 09:32:16 +1000
Message-Id: <1179271936.23574.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 21:47 +1000, Stephen Rothwell wrote:
> On Tue, 15 May 2007 21:42:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Tue, 15 May 2007 11:17:07 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > -		on_each_cpu(adjust_pge, 0, 0, 1);
> > > +		on_each_cpu(adjust_pge, (void *)0, 0, 1);
> >
> > Sorry?  What ever happened to a simple NULL?
> 
> Oh, I guess that is an explicit (numeric) 0 (of some type) caste to
> "void *" because of the prototype - rather than not passing anything?

Indeed.  We really want to pass a bool, but on_each_cpu uses a void *.
Hence the clearest solution seemed "(void *)0" and "(void *)1" in the
callers.

Thanks,
Rusty.


