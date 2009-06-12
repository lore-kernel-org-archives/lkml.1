Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbZFLHrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbZFLHrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZFLHrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:47:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37974 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZFLHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:47:38 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu
In-Reply-To: <1244792380.7172.77.camel@pasglop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>  <1244792380.7172.77.camel@pasglop>
Date: Fri, 12 Jun 2009 10:47:40 +0300
Message-Id: <1244792860.30512.15.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, 2009-06-12 at 17:34 +1000, Benjamin Herrenschmidt wrote:
> > I don't like that approach at all. Fixing all the call sites... we are
> > changing things all over the place, we'll certainly miss some, and
> > honestly, it's none of the business of things like vmalloc to know about
> > things like what kmalloc flags are valid and when... 
> 
> Oh and btw, your patch alone doesn't fix powerpc, because it's missing
> a whole bunch of GFP_KERNEL's in the arch code... You would have to
> grep the entire kernel for things that check slab_is_available() and
> even then you'll be missing some.

Ah, the patch is not against current git so, yeah, I missed some.

On Fri, 2009-06-12 at 17:39 +1000, Benjamin Herrenschmidt wrote:
> For example, slab_is_available() didn't always exist, and so in the
> early days on powerpc, we used a mem_init_done global that is set form
> mem_init() (not perfect but works in practice). And we still have code
> using that to do the test.

IMHO, that would be a bug :-). But anyway, see the other thread for my
suggestion how to do what you want in a slightly cleaner way.

			Pekka

