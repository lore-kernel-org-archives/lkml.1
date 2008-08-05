Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYHEDOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYHEDOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYHEDOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:14:41 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:23586 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755355AbYHEDOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:14:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=R7PMex2YiBEIhlD/zEWJHxgFa9iT70+1fX1akFPzX4YG5MjTIb3ZugV0tck6eWXIkqfnWpZ5/ivhbuMniQlbZoPzv+Mm1Ipss9eyT+uwOY9150FncFtx9Gd52tGFxGSffQv7+WC1tgJuYvSbgineafM1eCEn19uvkuMJ/YrL38A=  ;
X-YMail-OSG: _II64uEVM1kPBrCsXgw4vUiPp9SAxpS.oMrNpngIrUvvjq4SkpFk8YNo5OinRabM62.obuMyiw9z.Vi6EXxW3yocp0KYNMB4i1esazHprki8wCLEN4wiz4cFZUWZ1c9iQp8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
Date: Tue, 5 Aug 2008 13:14:33 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au>
In-Reply-To: <200807311726.51816.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051314.33791.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 17:26, Nick Piggin wrote:
> Hi,
>
> I'm wondering if I could get a patch merged which changes all
> TestSetPageLocked and replaces them with trylock_page?

Yes? No?

The alternative is try to merge it via -mm or -next, but that just
wastes everybodies time with conflicts of having these differences
between -mm and mainline.


>
> It would be done so there are no functional changes.
>
> The reason I want to (aside from having a slightly more
> intuitive API), is to facilitate the implementation of lockdep
> on page lock, and also to use lock semantics bitops for the
> lock rather than the big-hammer barriers that come with
> test_and_set_bit.
>
> The lock bitops stuff is one of the parts of my patchset to speed
> up page lock functions (which results in nearly 50% faster
> pagecache throughput on my G5, and even slightly faster on x86)...
>
> Anyway, I remember you said these kinds of changes are appropriate
> for just after -rc1, and I agree it shouldn't cause much pain.
>
> Fixing up patch conflicts is literally a matter of
> s/!TestSetPageLocked/trylock_page
> s/TestSetPageLocked/!trylock_page
>
> Thoughts?
