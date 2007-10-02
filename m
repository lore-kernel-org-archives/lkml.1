Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbXJCBO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbXJCBO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXJCBOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:14:47 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:39696 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750766AbXJCBOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:14:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ycQSKfWrfYoV5fmoEm2pLLVS7P8nFDn6AYI8OarzIVRjSJeivS14Rf3pVm15AXc5aV35Aii1AOtqG/H7vZ4mOC1DjilJfPSQecfuTDeYFS8JjU1CBlV19GgXevyZvbjGoMu96VlkdXVnC1gIUyv3UAXW0rbOAfVIyE4b6S+Hlg4=  ;
X-YMail-OSG: gZY71CcVM1mDWcqTcAj3TrYurkQelIdP_BJx4JuWnqpSG0kYsremXm5ltYdBwj6Cjn9jp6PWAA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Date: Tue, 2 Oct 2007 18:43:14 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
References: <20070919033605.785839297@sgi.com> <200709281514.48293.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021843.15241.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 06:50, Christoph Lameter wrote:
> On Fri, 28 Sep 2007, Nick Piggin wrote:
> > I thought it was slower. Have you fixed the performance regression?
> > (OK, I read further down that you are still working on it but not
> > confirmed yet...)
>
> The problem is with the weird way of Intel testing and communication.
> Every 3-6 month or so they will tell you the system is X% up or down on
> arch Y (and they wont give you details because its somehow secret). And
> then there are conflicting statements by the two or so performance test
> departments. One of them repeatedly assured me that they do not see any
> regressions.

Just so long as there aren't known regressions that would require higher
order allocations to fix them.


> > OK, so long as it isn't going to depend on using higher order pages,
> > that's fine. (if they help even further as an optional thing, that's fine
> > too. You can turn them on your huge systems and not even bother about
> > adding this vmap fallback -- you won't have me to nag you about these
> > purely theoretical issues).
>
> Well the vmap fallback is generally useful AFAICT. Higher order
> allocations are common on some of our platforms. Order 1 failures even
> affect essential things like stacks that have nothing to do with SLUB and
> the LBS patchset.

I don't know if it is worth the trouble, though. The best thing to do is to
ensure that contiguous memory is not wasted on frivolous things... a few
order-1 or 2 allocations aren't too much of a problem.

The only high order allocation failure I've seen from fragmentation for a
long time IIRC are the order-3 failures coming from e1000. And obviously
they cannot use vmap.
