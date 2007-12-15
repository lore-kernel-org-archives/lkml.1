Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXLOGNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXLOGNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXLOGNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:13:09 -0500
Received: from waste.org ([66.93.16.53]:38308 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbXLOGNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:13:08 -0500
Date: Sat, 15 Dec 2007 00:12:00 -0600
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215061200.GP19691@waste.org>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org> <20071215041659.GB25324@gondor.apana.org.au> <20071215055218.GM19691@waste.org> <20071215060449.GA26199@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215060449.GA26199@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 02:04:49PM +0800, Herbert Xu wrote:
> On Fri, Dec 14, 2007 at 11:52:18PM -0600, Matt Mackall wrote:
> >
> > No. The code as written above should reduce to:
> > 
> > 	if (val == NULL)
> > 		return -EFAULT;
> > 
> > If I hadn't wanted to return -EFAULT in this case, I would have just written:
> > 
> > 	WARN_ON(val == NULL);
> 
> Well the only reason I introduced
> 
> 	if (WARN_ON)
> 
> is so that what would otherwise be a BUG_ON condition would have
> a chance to get written to disk when invoked from an IRQ handler.
> 
> > I don't want code that was running safely (ie returning -EFAULT) to
> > start crashing the system just because I've, say, disabled printk.
> > That's creating an obnoxious heisenbug.
> 
> I'm disappointed that it has been used in ways that it shouldn't
> have been.
> 
> I suppose we'll have to either introduce a new primitive or just
> go back to using BUG_ON.

Seems we haven't yet reached concensus on what an appropriate use for
BUG_ON is. There's a fairly large camp who think that there are
basically no good reasons to outright crash a machine and that WARN_ON
should replace BUG_ON everywhere.

I tend to agree with this position, except when it comes to handling
filesystems, where panic is often (but not always) the right thing to
do.

-- 
Mathematics is the supreme nostalgia of our time.
