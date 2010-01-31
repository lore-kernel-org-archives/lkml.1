Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140Ab0AaUIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0AaUIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560Ab0AaUIr
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:08:47 -0500
Received: from waste.org ([173.11.57.241]:52673 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab0AaUIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:08:47 -0500
Subject: Re: [PATCH 09/10] mm/slab.c: Fix continuation line formats
From: Matt Mackall <mpm@selenic.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
In-Reply-To: <9d64ab1e1d69c750d53a398e09fe5da2437668c5.1264967500.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
	 <9d64ab1e1d69c750d53a398e09fe5da2437668c5.1264967500.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 14:08:43 -0600
Message-ID: <1264968523.3536.1801.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-31 at 12:02 -0800, Joe Perches wrote:
> String constants that are continued on subsequent lines with \
> are not good.

> The characters between seq_printf elements are tabs.
> That was probably not intentional, but isn't being changed.
> It's behind an #ifdef, so it could probably become a single space.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  mm/slab.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 7451bda..9964619 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4228,8 +4228,8 @@ static int s_show(struct seq_file *m, void *p)
>  		unsigned long node_frees = cachep->node_frees;
>  		unsigned long overflows = cachep->node_overflow;
>  
> -		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu \
> -				%4lu %4lu %4lu %4lu %4lu", allocs, high, grown,
> +		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu 				%4lu %4lu %4lu %4lu %4lu",
> +				allocs, high, grown,

Yuck. The right way to do this is by mergeable adjacent strings, eg:

printk("part 1..."
       " part 2...", ...);

-- 
http://selenic.com : development and support for Mercurial and Linux


