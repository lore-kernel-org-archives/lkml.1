Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbXINMog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbXINMog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXINMo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:44:27 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:23644 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754029AbXINMoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:44:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4+zzTKJZwqHPHYToq/Y0W1nGmGot5UmQkwrdrWI7dlAsc/ymDNy1uO2ZrYOQ6/n3HPx0LfYByQ00gIdGENRj0/Er6hI0idlrzKRMquW+Wek+FGpAKHIBmdLFS5ggNX5KrCkJRyJg2p7Z8AfUmWdmFA14/JuCdAnHCPnHW8/my2w=  ;
X-YMail-OSG: 5.GR7DkVM1nNbq3aesokpECV42kNf8dkYZ8LlDlI8G5t0vhV9U3Ai0_vt4W_ERwjUSAC07jdvw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Fri, 14 Sep 2007 06:51:29 +1000
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
References: <20070911060349.993975297@sgi.com> <200709120407.48344.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709121551340.4204@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709121551340.4204@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709140651.30735.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 09:06, Christoph Lameter wrote:
> On Wed, 12 Sep 2007, Nick Piggin wrote:

> > So lumpy reclaim does not change my formula nor significantly help
> > against a fragmentation attack. AFAIKS.
>
> Lumpy reclaim improves the situation significantly because the
> overwhelming majority of allocation during the lifetime of a systems are
> movable and thus it is able to opportunistically restore the availability
> of higher order pages by reclaiming neighboring pages.

I'm talking about non movable allocations.


> > [*] ok, this isn't quite true because if you can actually put a hard
> > limit on unmovable allocations then anti-frag will fundamentally help --
> > get back to me on that when you get patches to move most of the obvious 
> > ones.
>
> We have this hard limit using ZONE_MOVABLE in 2.6.23.

So we're back to 2nd class support.


> > Sure, and I pointed out the theoretical figure for 64K pages as well. Is
> > that figure not problematic to you? Where do you draw the limit for what
> > is acceptable? Why? What happens with tiny memory machines where a
> > reserve or even the anti-frag patches may not be acceptable and/or work
> > very well? When do you require reserve pools? Why are reserve pools
> > acceptable for first-class support of filesystems when it has been very
> > loudly been made a known policy decision by Linus in the past (and for
> > some valid reasons) that we should not put limits on the sizes of caches
> > in the kernel.
>
> 64K pages may problematic because it is above the PAGE_ORDER_COSTLY in
> 2.6.23. 32K is currently much safer because lumpy reclaim can restore
> these and does so on my systems. I expect the situation for 64K pages to
> improve when more of Mel's patches go in. We have long term experience
> with 32k sized allocation through Andrew's tree.
>
> Reserve pools as handled (by the not yet available) large page pool
> patches (which again has altogether another purpose) are not a limit. The
> reserve pools are used to provide a mininum of higher order pages that is
> not broken down in order to insure that a mininum number of the desired
> order of pages is even available in your worst case scenario. Mainly I
> think that is needed during the period when memory defragmentation is
> still under development.

fsblock doesn't need any of those hacks, of course.
