Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZHGC2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZHGC2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbZHGC2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:28:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:47869 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346AbZHGC2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:28:37 -0400
Cc: timur@freescale.com, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Message-Id: <E4B968CE-5739-455A-9231-8908289B9466@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908011052290.23408@ask.diku.dk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 1/10] arch/powerpc/sysdev/qe_lib: introduce missing kfree
Date: Thu, 6 Aug 2009 21:26:23 -0500
References: <Pine.LNX.4.64.0908011052290.23408@ask.diku.dk>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1, 2009, at 3:52 AM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
>
> Error handling code following a kzalloc should free the allocated  
> data.
>
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,f1,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
>
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>     when != if (...) { <+...x...+> }
> (
> x->f1 = E
> |
> (x->f1 == NULL || ...)
> |
> f(...,x->f1,...)
> )
> ...>
> (
> return \(0\|<+...x...+>\|ptr\);
> |
> return@p2 ...;
> )
>
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
>
> print "* file: %s kmalloc %s return %s" %  
> (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
> arch/powerpc/sysdev/qe_lib/qe_ic.c  |    5 ++++-
> 1 files changed, 4 insertions(+), 1 deletions(-)

applied to next

- k
