Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXJSB5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXJSB5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 21:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761128AbXJSB5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 21:57:18 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:39009 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760888AbXJSB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 21:57:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AK4HPuFQAQDVs7nYIz/PNeLUD0nIFjplV1SK57nVjTIUSNthKxdaMomXM+Xi2JDp/s8JHEd6JpOFmJxDs85ieH521Y83tkqh5s46JEUNdyZwrTD4zGSczXWin07STSAUxFHtyYw5iA2dNG0GNZ0kHrcwTURcsPTXnG5/9DOCF1Y=  ;
X-YMail-OSG: TJ37tBMVM1mGSFGJDHud3V6H0IMadEqo.txbMFDrTtIPpgi2AcNnt3.fNxlr5sBs.11UiKVE2w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: SLUB: Avoid atomic operation for slab_unlock
Date: Fri, 19 Oct 2007 11:56:42 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, linux-mm@kvack.org
References: <Pine.LNX.4.64.0710181514310.3584@schroedinger.engr.sgi.com> <200710190949.01019.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710181817380.4194@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710181817380.4194@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191156.43049.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 11:21, Christoph Lameter wrote:
> On Fri, 19 Oct 2007, Nick Piggin wrote:
> > Ah, thanks, but can we just use my earlier patch that does the
> > proper __bit_spin_unlock which is provided by
> > bit_spin_lock-use-lock-bitops.patch
>
> Ok.
>
> > This primitive should have a better chance at being correct, and
> > also potentially be more optimised for each architecture (it
> > only has to provide release consistency).
>
> Yes that is what I attempted to do with the write barrier. To my knowledge
> there are no reads that could bleed out and I wanted to avoid a full fence
> instruction there.

Oh, OK. Bit risky ;) You might be right, but anyway I think it
should be just as fast with the optimised bit_unlock on most
architectures.

Which reminds me, it would be interesting to test the ia64
implementation I did. For the non-atomic unlock, I'm actually
doing an atomic operation there so that it can use the release
barrier rather than the mf. Maybe it's faster the other way around
though? Will be useful to test with something that isn't a trivial
loop, so the slub case would be a good benchmark.

