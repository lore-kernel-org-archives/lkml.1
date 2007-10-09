Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbXJJCDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbXJJCDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 22:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXJJCDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 22:03:33 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:22232 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751537AbXJJCDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 22:03:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rQp7GieutWCK2VB8iDM1OEmCgWqCCRUwC+zceS+saVF+FXE6cZOJgHZst6ecV2CtOWrKpGDHaT0uOVCaIdSnJIies8DajvLVpsdR4NUlLOsReL4iEaz1oTng2L0bJf5ejPQFGKwCHq9cj7A2Fo8zyo1JGEndd/puQX0WGo0OhP8=  ;
X-YMail-OSG: NexIsloVM1nxKGY4m7vZ4zFLjuu5.i1cVPqaBGqTsSDVRx.PtxQ628yqdFbPelzC6s_EGabkIQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: remove zero_page (was Re: -mm merge plans for 2.6.24)
Date: Tue, 9 Oct 2007 19:31:51 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <200710090117.47610.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0710090750020.5039@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710090750020.5039@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710091931.51564.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 00:52, Linus Torvalds wrote:
> On Tue, 9 Oct 2007, Nick Piggin wrote:
> > I have done some tests which indicate a couple of very basic common tools
> > don't do much zero-page activity (ie. kbuild). And also combined with
> > some logical arguments to say that a "sane" app wouldn't be using
> > zero_page much. (basically -- if the app cares about memory or cache
> > footprint and is using many pages of zeroes, then it should have a more
> > compressed representation of zeroes anyway).
>
> One of the things that zero-page has been used for is absolutely *huge*
> (but sparse) arrays in Fortan programs.
>
> At least in traditional fortran, it was very hard to do dynamic
> allocations, so people would allocate the *maximum* array statically, and
> then not necessarily use everything. I don't know if the pages ever even
> got paged in,

In which case, they would not be using the ZERO_PAGE?
If they were paging in (ie. reading) huge reams of zeroes,
then maybe their algorithms aren't so good anyway? (I don't
know).


> but this is the kind of usage which is *not* insane. 

Yeah, that's why I use the double quotes... I wonder how to
find out, though. I guess I could ask SGI if they could ask
around -- but that still comes back to the problem of not being
able to ever conclusively show that there are no real users of
the ZERO_PAGE.

Where do you suggest I go from here? Is there any way I can
convince you to try it? Make it a config option? (just kidding)
