Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYIJUhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYIJUhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYIJUhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:37:23 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:57889 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYIJUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:37:23 -0400
Date: Wed, 10 Sep 2008 22:37:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Julia Lawall <julia@diku.dk>
cc: zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] arch/m68k/mm/kmap.c: introduce missing kfree
In-Reply-To: <Pine.LNX.4.64.0809101357440.15308@pc-004.diku.dk>
Message-ID: <Pine.LNX.4.64.0809102237040.29543@anakin>
References: <Pine.LNX.4.64.0809101357440.15308@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kmalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> (
> if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
> |
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> )
> <... when != x
>      when != if (...) { <+...x...+> }
> x->f = E
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  arch/m68k/mm/kmap.c           |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

Thanks, queued for 2.6.28.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
