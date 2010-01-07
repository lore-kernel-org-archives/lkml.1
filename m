Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561Ab0AGMME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0AGMME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 07:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131Ab0AGMMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 07:12:00 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40098 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0AGMMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 07:12:00 -0500
Message-ID: <4B45CF8E.7000707@cs.helsinki.fi>
Date: Thu, 07 Jan 2010 14:11:58 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] slab: initialize unused alien cache entry as NULL
 at alloc_alien_cache().
References: <4B443AE3.2080800@linux.intel.com>
In-Reply-To: <4B443AE3.2080800@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haicheng Li kirjoitti:
> Comparing with existing code, it's a simpler way to use kzalloc_node()
> to ensure that each unused alien cache entry is NULL.
> 
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  mm/slab.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 7dfa481..5d1a782 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -971,13 +971,11 @@ static struct array_cache **alloc_alien_cache(int 
> node, int limit, gfp_t gfp)
> 
>      if (limit > 1)
>          limit = 12;
> -    ac_ptr = kmalloc_node(memsize, gfp, node);
> +    ac_ptr = kzalloc_node(memsize, gfp, node);
>      if (ac_ptr) {
>          for_each_node(i) {
> -            if (i == node || !node_online(i)) {
> -                ac_ptr[i] = NULL;
> +            if (i == node || !node_online(i))
>                  continue;
> -            }
>              ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
>              if (!ac_ptr[i]) {
>                  for (i--; i >= 0; i--)

Christoph? Matt?
