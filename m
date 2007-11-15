Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbXKOTnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbXKOTnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763493AbXKOTnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:43:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43065 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbXKOTnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:43:06 -0500
Subject: Re: [RFC] fuse writable mmap design
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <E1IskWl-0000oJ-00@dorka.pomaz.szeredi.hu>
References: <E1IshIR-0000fE-00@dorka.pomaz.szeredi.hu>
	 <1195154530.22457.16.camel@lappy>
	 <E1IskWl-0000oJ-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 20:42:38 +0100
Message-Id: <1195155759.22457.29.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-15 at 20:37 +0100, Miklos Szeredi wrote:
> > I'm somewhat confused by the complexity. Currently we can already have a
> > lot of dirty pages from FUSE (up to the per BDI dirty limit - so
> > basically up to the total dirty limit).
> > 
> > How is having them dirty from mmap'ed writes different?
> 
> Nope, fuse never had dirty pages.  It does normal writes
> synchronously, just updating the cache.
> 
> The dirty accounting and then the per-bdi throttling basically made it
> possible _at_all_ to have a chance at a writepage implementation which
> is not deadlocky (so thanks for those ;).
> 
> But there's still the throttle_vm_writeout() thing, and the other
> places where the kernel is waiting for a write to complete, which just
> cannot be done within a constrained time if an unprivileged userspace
> process is involved.

Ah, ok, your initial story missed this part (not being intimately
familiar with FUSE made all that somewhat obscure).

The next point then, I'd expect your fuse_page_mkwrite() to push
writeout of your 32-odd mmap pages instead of poll.



