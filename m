Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbZEaQTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbZEaQTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 12:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZEaQTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 12:19:30 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:47051 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759175AbZEaQT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 12:19:28 -0400
Date: Sun, 31 May 2009 17:18:42 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver
Message-ID: <20090531161842.GB30640@linux-mips.org>
References: <1243350141-883-1-git-send-email-anemo@mba.ocn.ne.jp> <20090529162907.9cb1bba2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529162907.9cb1bba2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 04:29:07PM -0700, Andrew Morton wrote:

> > +static u64 read_rng(void __iomem *base, unsigned int offset)
> > +{
> > +	/* Caller must disable interrupts */
> > +	return ____raw_readq(base + offset);
> > +}
> 
> What is the reasoning behind the local_irq_disable() requirement?
> 
> Because I'm wondering whether this is safe on SMP?

The problem are interrupts, not SMP.  readq is reading a 64-bit register
using a 64-bit load.  On a 32-bit kernel however interrupts or any
other processor exception would clobber the upper 32-bit of the processor
register so interrupts need to be disabled.  The "normal" readq
functions disable interrupts as necessary on a platform.  This code does
multiple read accesses so for efficiency sake it relies on the caller
handling interrupts explicitly.

Also this platform does not do SMP.

  Ralf
