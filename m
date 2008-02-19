Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbYBSWBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbYBSWBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759113AbYBSWBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:01:15 -0500
Received: from hu-out-0506.google.com ([72.14.214.239]:22012 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761817AbYBSWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=QfO8byzqC5ua+LKLCzYuLxbZBZzJXVw0dvml4R/Y8NFutQaoc9aFaE6WgiNcbYznxbquBiQ9BNf5auOGBxYFdxfjc6JoTri3UkpJ/15WtyHowU6dZGHIopG/Kpw8Asu+VIq+wVCSVdrK1kt9dY4RYJi7FJypz+59oFoFzob8ukQ=
Date: Wed, 20 Feb 2008 01:01:06 +0300
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-sha1: RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Message-ID: <20080219220106.GB1756@martell.zuzino.mipt.ru>
References: <20080210140031.GA1754@martell.zuzino.mipt.ru> <20080212222704.GC2144@martell.zuzino.mipt.ru> <200802131117.37389.nickpiggin@yahoo.com.au> <200802131542.03026.nickpiggin@yahoo.com.au> <20080219204711.GA1756@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219204711.GA1756@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 11:47:11PM +0300,  wrote:
> On Wed, Feb 13, 2008 at 03:42:02PM +1100, Nick Piggin wrote:
> > On Wednesday 13 February 2008 11:17, Nick Piggin wrote:
> > > On Wednesday 13 February 2008 09:27, Alexey Dobriyan wrote:
> > 
> > > > It's a trivial dumb module which does nothing but loads and unloads.
> > > > I redid ftest03 later without any suspicious activity and it oopsed the
> > > > same way.
> > >
> > > Ah crap. Hmm, maybe I didn't consider all cases with my last patch to
> > > that code... is there an easy way to get the ftest03 source and run
> > > it?
> > 
> > OK I didn't realise it is a test from ltp.
> > 
> > But I can't reproduce it for the life of me with the latest git kernel
> > and latest ltp tarball.
> > 
> > Is it easy to reproduce?
> 
> Well, yes. SMP, non-preemptible kernel, (and maxcpus=1 really helps!)
> 
> 	while true; do
> 		./ftest03
> 	done
> 
> This alone seems stable, but starting whole LTP in parallel downs the box
> very quickly.
> 
> > Are you reproducing it simply by running the
> > ftest03 binary directly from the shell? How many times between oopses?
> > It is multi-process but no threads, so races should be minimal down
> > this path -- can you get an strace of the failing process?

Speaking of multi-proceseness, changing MAXCHILD to 1, nchild to 1,
AFAICS, generates one child which oopses the very same way (in parallel
with generic LTP) But, lowering MAXIOVCNT to 8 generates no oops.
