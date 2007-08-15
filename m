Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbXHOITR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbXHOITR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbXHOISu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:18:50 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:40813 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXHOISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:18:47 -0400
Date: Wed, 15 Aug 2007 10:18:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chris Snook <csnook@redhat.com>, satyam@infradead.org, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, davem@davemloft.net,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
	architectures
Message-ID: <20070815081841.GA16551@osiris.boeblingen.de.ibm.com>
References: <46C2350A.1010807@redhat.com> <E1ILCgh-00052A-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ILCgh-00052A-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 02:49:03PM +0800, Herbert Xu wrote:
> Chris Snook <csnook@redhat.com> wrote:
> > 
> > Because atomic operations are generally used for synchronization, which requires 
> > volatile behavior.  Most such codepaths currently use an inefficient barrier(). 
> >  Some forget to and we get bugs, because people assume that atomic_read() 
> > actually reads something, and atomic_write() actually writes something.  Worse, 
> > these are architecture-specific, even compiler version-specific bugs that are 
> > often difficult to track down.
> 
> I'm yet to see a single example from the current tree where
> this patch series is the correct solution.  So far the only
> example has been a buggy piece of code which has since been
> fixed with a cpu_relax.

Btw.: we still have

include/asm-i386/mach-es7000/mach_wakecpu.h:  while (!atomic_read(deassert));
include/asm-i386/mach-default/mach_wakecpu.h: while (!atomic_read(deassert));

Looks like they need to be fixed as well.
