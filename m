Return-Path: <linux-kernel-owner+w=401wt.eu-S932540AbZFLHkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbZFLHkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZFLHj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:39:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:49733 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbZFLHj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:39:58 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu
In-Reply-To: <1244792079.7172.74.camel@pasglop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 17:39:40 +1000
Message-Id: <1244792380.7172.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 17:34 +1000, Benjamin Herrenschmidt wrote:

> I don't like that approach at all. Fixing all the call sites... we are
> changing things all over the place, we'll certainly miss some, and
> honestly, it's none of the business of things like vmalloc to know about
> things like what kmalloc flags are valid and when... 

Oh and btw, your patch alone doesn't fix powerpc, because it's missing
a whole bunch of GFP_KERNEL's in the arch code... You would have to
grep the entire kernel for things that check slab_is_available() and
even then you'll be missing some.

For example, slab_is_available() didn't always exist, and so in the
early days on powerpc, we used a mem_init_done global that is set form
mem_init() (not perfect but works in practice). And we still have code
using that to do the test.

Anyway, I think changing all the call sites is the wrong approach,
especially for things that can routinely be called after boot when
GFP_KERNEL is the right thing to do.

Cheers,
Ben.


