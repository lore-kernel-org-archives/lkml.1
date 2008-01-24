Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYAXS57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYAXS57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 13:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYAXS5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 13:57:50 -0500
Received: from waste.org ([66.93.16.53]:54576 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbYAXS5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:57:49 -0500
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
	sys_msync()
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Anton Salikhmetov <salikhmetov@gmail.com>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <200801241236.01114.nickpiggin@yahoo.com.au>
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083504-git-send-email-salikhmetov@gmail.com>
	 <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org>
	 <200801241236.01114.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 12:56:13 -0600
Message-Id: <1201200973.3897.31.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 12:36 +1100, Nick Piggin wrote:
> On Thursday 24 January 2008 04:05, Linus Torvalds wrote:
> > On Wed, 23 Jan 2008, Anton Salikhmetov wrote:
> > > +
> > > +		if (pte_dirty(*pte) && pte_write(*pte)) {
> >
> > Not correct.
> >
> > You still need to check "pte_present()" before you can test any other
> > bits. For a non-present pte, none of the other bits are defined, and for
> > all we know there might be architectures out there that require them to
> > be non-dirty.
> >
> > As it is, you just possibly randomly corrupted the pte.
> >
> > Yeah, on all architectures I know of, it the pte is clear, neither of
> > those tests will trigger, so it just happens to work, but it's still
> > wrong.
> 
> Probably it can fail for !present nonlinear mappings on many
> architectures.

Definitely.

-- 
Mathematics is the supreme nostalgia of our time.

