Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbZFLIr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbZFLIr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbZFLIrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:47:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:42695 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbZFLIrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:47:19 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu
In-Reply-To: <1244794648.30512.21.camel@penberg-laptop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>  <1244792380.7172.77.camel@pasglop>
	 <1244794648.30512.21.camel@penberg-laptop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 18:47:06 +1000
Message-Id: <1244796426.7172.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 11:17 +0300, Pekka Enberg wrote:
> Hi Ben,
> 
> On Fri, 2009-06-12 at 17:39 +1000, Benjamin Herrenschmidt wrote:
> > For example, slab_is_available() didn't always exist, and so in the
> > early days on powerpc, we used a mem_init_done global that is set form
> > mem_init() (not perfect but works in practice). And we still have code
> > using that to do the test.
> 
> Looking at powerpc arch code, can we get rid of the *_maybe_bootmem()
> functions now? Or is slab initialization too late still? FWIW, I think
> one simple fix on PPC is to just clear __GFP_NOWAIT in those functions
> (all of them seem to be using GFP_KERNEL which is wrong during boot).

I -think- we still use those in setup_arch() so we can't get rid of that
completely yet.

Cheers,
Ben.

> 			Pekka
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

