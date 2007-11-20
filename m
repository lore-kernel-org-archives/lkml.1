Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbXKTSS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbXKTSS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXKTSST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:18:19 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3032 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbXKTSSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:18:18 -0500
Subject: Re: [KERNEL]: Avoid divide in IS_ALIGN
From: Joe Perches <joe@perches.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071120135607.GA18346@gondor.apana.org.au>
References: <20071120135607.GA18346@gondor.apana.org.au>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 10:17:15 -0800
Message-Id: <1195582635.4675.145.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 21:56 +0800, Herbert Xu wrote:
> [KERNEL]: Avoid divide in IS_ALIGN
> I was happy to discover the brand new IS_ALIGN macro and quickly
> used it in my code.  To my dismay I found that the generated code
> used division to perform the test.
> This patch fixes it by changing the % test to an &.  This avoids
> the division.

Perhaps this should use is_power_of_2?

#define IS_ALIGNED(x, a) 				\
	({ typeof(x) _a = (typeof(x))(a); 		\
	   is_power_of_2(_a) ? (((x) & (_a - 1)) == 0)	\
			     : (((x) % _a == 0); })

gcc -o2/oS seems to do the right thing.

