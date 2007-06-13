Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXFMGJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXFMGJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXFMGJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:09:13 -0400
Received: from waste.org ([66.93.16.53]:36019 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbXFMGJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:09:11 -0400
Date: Wed, 13 Jun 2007 01:08:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: linux@horizon.com
Cc: akpm@linux-foundation.org, bgilbert@cs.cmu.edu,
       linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] random: fix folding
Message-ID: <20070613060855.GY11115@waste.org>
References: <20070613052951.GI11166@waste.org> <20070613054521.18992.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613054521.18992.qmail@science.horizon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 01:45:21AM -0400, linux@horizon.com wrote:
> > Folding is done to minimize the theoretical possibility of systematic
> > weakness in the particular bits of the SHA1 hash output. The result of
> > this bug is that 16 out of 80 bits are un-folded. Without a major new
> > vulnerability being found in SHA1, this is harmless, but still worth
> > fixing.
> 
> Actually, even WITH a major new vulnerability found in SHA1, it's
> harmless.  Sorry to put BUG in caps earlier; it actually doesn't warrant
> the sort of adjective I used.  The purpose of the folding is to ensure that
> the feedback includes bits underivable from the output.  Just outputting
> the first 80 bits and feeding back all 160 would achieve that effect;
> the folding is of pretty infinitesimal benefit.

Well we're actually not feeding back those 160 bits. But we are
hashing over the entire pool and feeding -that- back beforehand, which
is equivalent.

> Note that last five rounds have as major outputs e, d, c, b, and a,
> in that order.  Thus, the first words are the "most hashed" and
> the ones most worth using as output... which happens naturally with
> no folding.

Indeed, though we actually want to keep random.c agnostic as to the
type of hash actually used.

> The folding is a submicroscopic bit of additional mixing.
> Frankly, the code size savings probably makes it worth deleting it.
> (That would also give you more flexibility to select the output/feedback
> ratio in whatever way you like.)

I'd tend to agree with you. Even if we did no folding at all in this
last stage, we already do plenty of feedback. For every 80 bits
extracted, we feed back at least.. 320.

-- 
Mathematics is the supreme nostalgia of our time.
