Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbZAVXOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbZAVXOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZAVXON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:14:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46247 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbZAVXOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:14:12 -0500
Date: Fri, 23 Jan 2009 00:13:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Lowengrub <lowdanie@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28 1/2] memory: improve find_vma
Message-ID: <20090122231358.GA27033@elte.hu>
References: <8c5a844a0901220851g1c21169al4452825564487b9a@mail.gmail.com> <Pine.LNX.4.64.0901221658550.14302@blonde.anvils> <8c5a844a0901221500m7af8ff45v169b6523ad9d7ad3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c5a844a0901221500m7af8ff45v169b6523ad9d7ad3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lowengrub <lowdanie@gmail.com> wrote:

> On Thu, Jan 22, 2009 at 7:22 PM, Hugh Dickins <hugh@veritas.com> wrote:
> > Do you have some performance figures to support this patch?
> > Some of the lmbench tests may be appropriate.
> >
> > The thing is, expanding vm_area_struct to include another pointer
> > will have its own cost, which may well outweigh the efficiency
> > (in one particular case) which you're adding.  Expanding mm_struct
> > for this would be much more palatable, but I don't think that flies.
> >
> > And it seems a little greedy to require both an rbtree and a doubly
> > linked list for working our way around the vmas.
> >
> > I suspect that originally your enhancement would only have hit when
> > extending the stack: which I guess isn't enough to justify the cost.
> > But it could well be that unmapped area handling has grown more
> > complex down the years, and you get some hits now from that.
> >
> Thanks for the reply.
> I ran an lmbench test on the 2.6.28 kernel and on the same kernel
> after applying the patch.  Here's a portion of the results with the
> format of
> test : standard kernel / kernel after patch
> 
> Simple syscall: 0.7419 / 0.4244 microseconds
> Simple read: 1.2071 / 0.7270 microseconds

there must be a significant measurement mistake here: none of your patches 
affect the 'simple syscall' path, nor the sys_read() path.

	Ingo
