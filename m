Return-Path: <linux-kernel-owner+w=401wt.eu-S1762633AbXLOGb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762633AbXLOGb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLOGbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:31:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:46344 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXLOGbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:31:47 -0500
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071214132755.GA18309@gondor.apana.org.au>
References: <20071214132755.GA18309@gondor.apana.org.au>
Content-Type: text/plain
Date: Sat, 15 Dec 2007 17:31:30 +1100
Message-Id: <1197700290.6696.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-14 at 21:27 +0800, Herbert Xu wrote:
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
> 
> The same change is made to WARN_ON_ONCE.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

That's something I've actually never quite liked... the fact that we
evaluate the expression anyway. I'm pretty happy with -not- evaluating
the expression when CONFIG_BUG is on most of the time since whatever is
in there is purely here for the sake of the BUG/WARN test.

I understand why some people may want it the other way around, but I
personally find it a very bad idea in the first place to write a normal
statement part of the program as

	BUG_ON(do_something());

It's way clearer to me I believe to write:

	rc = do_something();
	BUG_ON(rc);

And thus, when I write:

	BUG_ON(do_sanity_check());

I'm actually execting the function call to disappear when CONFIG_BUG
is turned off...

Cheers,
Ben.


