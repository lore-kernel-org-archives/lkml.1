Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXAYMCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXAYMCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 07:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932884AbXAYMCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 07:02:37 -0500
Received: from [212.12.190.202] ([212.12.190.202]:32992 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932879AbXAYMCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 07:02:36 -0500
From: Al Boldi <a1426z@gawab.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC] Limit the size of the pagecache
Date: Thu, 25 Jan 2007 14:57:27 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200701250942.47321.a1426z@gawab.com> <45B86930.2090709@linux.vnet.ibm.com>
In-Reply-To: <45B86930.2090709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701251457.27813.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> Al Boldi wrote:
> > Rik van Riel wrote:
> >> Christoph Lameter wrote:
> >>> This is a patch using some of Aubrey's work plugging it in what is
> >>> IMHO the right way. Feel free to improve on it. I have gotten
> >>> repeatedly requests to be able to limit the pagecache.
> >>
> >> IMHO it's a bad hack.
> >>
> >> It would be better to identify the problem this "feature" is
> >> trying to fix, and then fix the root cause.
> >
> > Ok, here is the problem:  kswapd.
> >
> > Limiting the page-cache memory inhibits invoking kswapd needlessly,
> > aiding performance and easing OOM pressures.
>
> Apart from kswapd, limiting pagecache helps performance of
> applications by not eating away their ANON pages or other parts of its
> resident data set.  When there is enough free memory, then there is no
> performance issue.  However memory is always utilized to the max.
> Hence every pagecache page that is allocated should come from some
> application's RSS, or from cold pagecache page.  If that page was
> stolen from some application, then that application pays the price for
> swapping or reading the page back to memory.  This scenario is what we
>  want to avoid.  All that we are trying to achieve is that pagecache
> eats a (unmapped) pagecache page and not steal memory from other
> important application's resident set.

Agreed 100%.  Thanks for expanding exactly what I meant.

> Certainly this should be a configurable option and kernel's behavior
> should not be changed in general.
>
> > I tried the patch; it works.
> >
> :)
> :
> > But it needs a bit of debugging.  Setting pagecache_ratio = 1 either
> > deadlocks or reduces thru-put to < 1mb/s.
>
> Yes, going below 5% on my 1GB RAM machine causes severe performance
> problems.  We need to hard wire a reasonable lower limit and not
> provide a noose for the end user to tie around!

One reason to test full range settings, is to expose underlying system 
problems, like scalability.  By limiting the range, you only hide a problem 
that was exposed.


Thanks!

--
Al

