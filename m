Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbXLOERY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbXLOERY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763816AbXLOERI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:17:08 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1683 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755284AbXLOERH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:17:07 -0500
Date: Sat, 15 Dec 2007 12:16:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215041659.GB25324@gondor.apana.org.au>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214180246.GT17536@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 12:02:46PM -0600, Matt Mackall wrote:
>
> I added CONFIG_BUG, and I think the current behavior is correct. As
> you've noticed, we have to evaluate condition, it may have
> side-effects. And if code does:
> 
> 	/* this indicates a driver bug, report and fail gracefully */
> 	if (WARN_ON(val == NULL))
> 		return -EFAULT;

That's exactly the sort of use I had in mind :) I'm actually the
one who added the ability to use WARN_ON inside an if clause.

Just as the case of a BUG_ON, a WARN_ON should never occur in
practice, unless there is a bug which the code is not aware of.
As such we want it to go away completely if CONFIG_BUG is off.

> ..we surely want it to continue returning -EFAULT, regardless of
> whether we log it, no? What use case did you have in mind?

If you're using it for a scenario which is known to actually
occur, then some other mechanism should be chosen in place of
WARN_ON.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
