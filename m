Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbXIQNBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbXIQNBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXIQNBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:01:00 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:39503 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752891AbXIQNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:00:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=szSZpS22cEIDn9K/595G4hW/O5TrqBh5/H/xXCq2ylZVZub/cS0KbnrpRf94mA9zJQ1zkYeOCU2T+7rpTzKx/FRfuiSzWIGkDbPieKSIzz8UyD5tPMFRRCXtYqmltpLr6PkStT9g5jrNlBruY36RHKnO6g052qeH7sDxV8bRl7E=  ;
X-YMail-OSG: z0l2zxsVM1ngb4cXo9EOcsF.75kdDpcWbOuMOTJbJuFAM8y1UOLB8bDLceKWIPfLT2VwNIUOrA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Sun, 16 Sep 2007 18:22:46 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709140651.30735.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709141048320.15813@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709141048320.15813@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161822.47879.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007 03:52, Christoph Lameter wrote:
> On Fri, 14 Sep 2007, Nick Piggin wrote:
> > > > [*] ok, this isn't quite true because if you can actually put a hard
> > > > limit on unmovable allocations then anti-frag will fundamentally help
> > > > -- get back to me on that when you get patches to move most of the
> > > > obvious ones.
> > >
> > > We have this hard limit using ZONE_MOVABLE in 2.6.23.
> >
> > So we're back to 2nd class support.
>
> 2nd class support for me means a feature that is not enabled by default
> but that can be enabled in order to increase performance. The 2nd class
> support is there because we are not yet sure about the maturity of the
> memory allocation methods.

I'd rather an approach that does not require all these hacks.


> > > Reserve pools as handled (by the not yet available) large page pool
> > > patches (which again has altogether another purpose) are not a limit.
> > > The reserve pools are used to provide a mininum of higher order pages
> > > that is not broken down in order to insure that a mininum number of the
> > > desired order of pages is even available in your worst case scenario.
> > > Mainly I think that is needed during the period when memory
> > > defragmentation is still under development.
> >
> > fsblock doesn't need any of those hacks, of course.
>
> Nor does mine for the low orders that we are considering. For order >
> MAX_ORDER this is unavoidable since the page allocator cannot manage such
> large pages. It can be used for lower order if there are issues (that I
> have not seen yet).

Or we can just avoid all doubt (and doesn't have arbitrary limitations
according to what you think might be reasonable or how well the
system actually behaves).
