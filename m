Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZFVJJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZFVJJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZFVJJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:09:02 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33661 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZFVJJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:09:02 -0400
Subject: Re: linux-next: slab tree build failure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1245408008.16880.9.camel@pasglop>
References: <20090619141626.a60bba01.sfr@canb.auug.org.au>
	 <1245408008.16880.9.camel@pasglop>
Date: Mon, 22 Jun 2009 12:09:02 +0300
Message-Id: <1245661742.18751.32.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 20:40 +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2009-06-19 at 14:16 +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > 
> > mm/slqb.c:75: error: 'SLAB_GFP_BOOT_MASK' undeclared here (not in a function)
> > 
> > Caused by commit df548b0bbaf2d4d16ce52d2f5ccdc1cfded70e06 ("SLQB: Fix
> > early boot allocations") from the slab tree interacting with commit
> > dcce284a259373f9e5570f2e33f79eca84fcf565 ("mm: Extend gfp masking to the
> > page allocator") that entered Linus' tree today.
> > 
> > I have applied this patch for today:
> 
> The right fix is to remove slab_gfp_mask from slqb.c and use
> the global gfp_allowed_mask instead.

This should be fixed now in slab.git. Something in SQLB is still
enabling interrupts during early boot but I don't have the time to look
at it in more detail right now.

			Pekka

