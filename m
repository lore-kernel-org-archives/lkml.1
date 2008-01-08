Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYAHHoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYAHHoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYAHHoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:44:46 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:31330 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750727AbYAHHop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:44:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GzGrCvG3XTv6jytxREpjNHkDsvVv/fLInWayQHJIxCvRZj+QVJZ70svdT4oKJ0uPQs6/PyEOfSrdNsKU4rpUqZuWHAU0RzZIcHTAJgutWdqfqsjFid73WvrE0M9gESOdNByues+pxbzVmne/exYjFgIzfoG9RLP77cfiLx+4Ojo=  ;
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: free_pages_check
Date: Tue, 8 Jan 2008 18:44:22 +1100
User-Agent: KMail/1.9.5
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>
References: <86802c440801071843p583f390as53f8b600622b93b2@mail.gmail.com> <200801081434.14723.nickpiggin@yahoo.com.au> <47830DCF.3080306@zytor.com>
In-Reply-To: <47830DCF.3080306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081844.22448.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 16:44, H. Peter Anvin wrote:
> Nick Piggin wrote:
> > On Tuesday 08 January 2008 13:43, Yinghai Lu wrote:
> >> wonder why free_pages_check mm/page_alloc.c is using bit OR than logical
> >> OR
> >>
> >> @@ -450,9 +450,9 @@ static inline void __free_one_page(struc
> >>
> >>  static inline int free_pages_check(struct page *page)
> >>  {
> >> -       if (unlikely(page_mapcount(page) |
> >> -               (page->mapping != NULL)  |
> >> -               (page_count(page) != 0)  |
> >> +       if (unlikely(page_mapcount(page) ||
> >> +               (page->mapping != NULL)  ||
> >> +               (page_count(page) != 0)  ||
> >>                 (page->flags & (
> >>                         1 << PG_lru     |
> >>                         1 << PG_private |
> >
> > Because the positive case is extremely rare, so there is no benefit (nor
> > any correctness requirement) for short-circuit evaluation, and we don't
> > want to have all the branches that it involves. I think it is 3 more
> > conditional jumps.
>
> Depends on how smart the compiler is.  If the page_() functions are
> inlines or macros, there is only one pointer reference involved and it
> should be able to do that transformation.  Whether or not gcc is that
> smart is another matter.

Mine is not.
