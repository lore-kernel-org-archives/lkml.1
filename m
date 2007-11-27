Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbXK0Fxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbXK0Fxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXK0FxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:53:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbXK0FxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:53:23 -0500
Date: Mon, 26 Nov 2007 21:53:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bron Gondwana" <brong@fastmail.fm>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rob Mueller" <robm@fastmail.fm>
Subject: Re: [PATCH 1/1] mm: add dirty_highmem option
Message-Id: <20071126215315.3422eaa2.akpm@linux-foundation.org>
In-Reply-To: <1196141064.31920.1223402735@webmail.messagingengine.com>
References: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
	<20071115052538.GA21522@brong.net>
	<alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
	<20071115115049.GA8297@brong.net>
	<alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
	<1195155601.22457.25.camel@lappy>
	<1195159457.22457.35.camel@lappy>
	<alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
	<20071122034204.GA14079@brong.net>
	<20071126205428.c264ccff.akpm@linux-foundation.org>
	<1196141064.31920.1223402735@webmail.messagingengine.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 16:24:24 +1100 "Bron Gondwana" <brong@fastmail.fm> wrote:

> On Mon, 26 Nov 2007 20:54:28 -0800, "Andrew Morton" <akpm@linux-foundation.org> said:
> > On Thu, 22 Nov 2007 14:42:04 +1100 Bron Gondwana <brong@fastmail.fm>
> > wrote:
> > 
> > >  /*
> > > + * free highmem will not be subtracted from the total free memory
> > > + * for calculating free ratios if vm_dirty_highmem is true
> > > + */
> > > +int vm_dirty_highmem;
> > 
> > One would expect that setting dirty_highmem to true would cause highmem
> > to
> > be accounted in dirty-memory calculations.  However with this change
> > reality is in fact the inverse of that.
> > 
> > So how about this?
> 
> Actually, I'm confused now.  Maybe I chose a bad name to begin with.
> Does it mean "I am allowed to dirty high memory" or "my high memory
> will be dirty if this is on"?

But we're always allowed to dirty highmem - there'd be no point in having
it otherwise.  Hence the term dirty_highmem is confusing.

umm, really you want
/proc/sys/vm/dont-account-highmem-in-dirty-memory-calculations, only
shorter.

Do you agree?

If so, then it's still not a very pleasing interface - setting something to
"true" to disable a particular piece of kernel behaviour implies a single
negation which we don't really need.

It would be simpler to have
/proc/sys/vm/do-account-highmem-in-dirty-memory-calculations,
defaulting to "true" - this has no negations.

So... how about /proc/sys/vm/, umm.

<looks at inbox, brain explodes>

OK, I give up.  Please see if you can think of something less confusing
which involves no negations?

Thanks.
