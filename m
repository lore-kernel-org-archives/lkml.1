Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbXFXIjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbXFXIjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 04:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXFXIjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 04:39:37 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3349 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXFXIjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 04:39:35 -0400
Date: Sun, 24 Jun 2007 09:38:50 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
Message-ID: <20070624083849.GA19079@flint.arm.linux.org.uk>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com> <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com> <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org> <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 07:39:33PM +0100, Hugh Dickins wrote:
> On Fri, 22 Jun 2007, Christoph Lameter wrote:
> > 
> > Add VM_BUG_ON in case someone uses page_mapping on a slab page
> > 
> > Detect slab objects being passed to the page oriented functions of the VM.
> > 
> > It is not sufficient to simply return NULL because the functions calling
> > page_mapping may depend on other items of the page_struct also to be setup
> > properly. Moreover the slab object may not be properly aligned. The page 
> > orientedfunctions of the VM expect to operate on page aligned, page sized 
> > objects. operations on objects straddling page boundaries may only affect 
> > the objects partially which may lead to surprising results.
> > 
> > It is better to detect eventually remaining uses and eliminate them.
> > 
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> I'm quite happy with this approach for 2.6.23-rc, along with your ARM
> dma_map patch which (if I understood aright) rmk approved.

I didn't approve it.  Please re-read my reply - there are still some
unanswered questions in it which _really_ need answering.

The report talks about the AT91 machines.  These machines do not have
cache coherent DMA.  Therefore, the code being patched should be
optimised away by the compiler. *Or* we have even bigger problems.

Please forward the original problem report.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
