Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXLOGFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXLOGFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXLOGFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:05:00 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2508 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbXLOGE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:04:59 -0500
Date: Sat, 15 Dec 2007 14:04:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215060449.GA26199@gondor.apana.org.au>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org> <20071215041659.GB25324@gondor.apana.org.au> <20071215055218.GM19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215055218.GM19691@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 11:52:18PM -0600, Matt Mackall wrote:
>
> No. The code as written above should reduce to:
> 
> 	if (val == NULL)
> 		return -EFAULT;
> 
> If I hadn't wanted to return -EFAULT in this case, I would have just written:
> 
> 	WARN_ON(val == NULL);

Well the only reason I introduced

	if (WARN_ON)

is so that what would otherwise be a BUG_ON condition would have
a chance to get written to disk when invoked from an IRQ handler.

> I don't want code that was running safely (ie returning -EFAULT) to
> start crashing the system just because I've, say, disabled printk.
> That's creating an obnoxious heisenbug.

I'm disappointed that it has been used in ways that it shouldn't
have been.

I suppose we'll have to either introduce a new primitive or just
go back to using BUG_ON.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
