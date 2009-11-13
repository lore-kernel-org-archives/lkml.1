Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbZKMVMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbZKMVMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZKMVM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:12:29 -0500
Received: from sous-sol.org ([216.99.217.87]:60325 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932269AbZKMVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:12:28 -0500
Date: Fri, 13 Nov 2009 13:11:04 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
Message-ID: <20091113211104.GA27945@sequoia.sous-sol.org>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp> <84144f020911091213j393a9761pe13808d1e091e169@mail.gmail.com> <84144f020911091221n1d025d9bv3915751bf474b47a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020911091221n1d025d9bv3915751bf474b47a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> On Mon, Nov 9, 2009 at 10:13 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >>        for (cursor = start; cursor < end; cursor += BITS_PER_LONG) {
> >> -               unsigned long idx, vec;
> >> +               unsigned long vec;
> >>
> >> -               idx = cursor - start;
> >> -               vec = ~map[idx / BITS_PER_LONG];
> >> +               if (map) {
> >> +                       unsigned long idx = cursor - start;
> >> +                       vec = ~map[idx / BITS_PER_LONG];
> >> +               } else {
> >> +                       if (end - cursor >= BITS_PER_LONG)
> >> +                               vec = ~0UL;
> >
> > Why do we need the above?
> 
> OK, I figured that out. I'm not sure why you want to play tricks with
> "vec" when you could just add a new helper that calls
> __free_pages_bootmem() for the full contiguous page range.

I did it this way since it's simple enough and allows for high-order
frees (these will nearly all be high-order) and keeps the same core
code exercised in each path.  You can't do a higher order free
w/ __free_pages_bootmem() w/out conforming to its requirements.
I don't care either way.

thanks,
-chris
