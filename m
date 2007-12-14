Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbXLNSDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbXLNSDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXLNSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:03:17 -0500
Received: from waste.org ([66.93.16.53]:35505 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXLNSDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:03:17 -0500
Date: Fri, 14 Dec 2007 12:02:46 -0600
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071214180246.GT17536@waste.org>
References: <20071214132755.GA18309@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214132755.GA18309@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 09:27:55PM +0800, Herbert Xu wrote:
> Hi:
> 
> [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
> 
> The description of CONFIG_BUG clearly states that both BUG and
> WARN_ON may be skipped.  However, our actual implementation still
> checks the condition on WARN_ON if it's used as part of an if
> statement or such.
> 
> This patch makes it return 0 after evaluating the expression
> if CONFIG_BUG is disabled.  This is consistent with the spirit
> of the CONFIG_BUG option.

I added CONFIG_BUG, and I think the current behavior is correct. As
you've noticed, we have to evaluate condition, it may have
side-effects. And if code does:

	/* this indicates a driver bug, report and fail gracefully */
	if (WARN_ON(val == NULL))
		return -EFAULT;

..we surely want it to continue returning -EFAULT, regardless of
whether we log it, no? What use case did you have in mind?

-- 
Mathematics is the supreme nostalgia of our time.
