Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZHGC0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZHGC0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZHGC0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:26:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:50791 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZHGC0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:26:50 -0400
Cc: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <44DC26BA-29CF-4DBA-8D9F-1AB950F8B861@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908021044330.15557@ask.diku.dk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 2/10] arch/powerpc: introduce missing kfree
Date: Thu, 6 Aug 2009 21:26:38 -0500
References: <Pine.LNX.4.64.0908021044330.15557@ask.diku.dk>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2, 2009, at 3:44 AM, Julia Lawall wrote:

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
> arch/powerpc/sysdev/ipic.c          |    4 +++-
> 1 files changed, 3 insertions(+), 1 deletions(-)


applied to next

- k

