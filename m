Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXFDMiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXFDMiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbXFDMiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:38:09 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:45406 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXFDMiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:38:07 -0400
Message-ID: <466408C2.3000406@openvz.org>
Date: Mon, 04 Jun 2007 16:42:42 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: akpm@osdl.org
CC: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [PATCH -mm] Fix /proc/slab_allocators re seq_list_next() conversion
References: <20070604122616.GA6155@localhost.sw.ru>
In-Reply-To: <20070604122616.GA6155@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Wrong pointer was used as kmem_cache pointer.
> 
> [Here /proc/slab_allocators appears as empty file, but it's just me, probably]
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Acked-by: Pavel Emelianov <xemul@openvz.org>

> ---
> 
>  mm/slab.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4401,7 +4401,7 @@ static void show_symbol(struct seq_file *m, unsigned long address)
>  
>  static int leaks_show(struct seq_file *m, void *p)
>  {
> -	struct kmem_cache *cachep = p;
> +	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, next);
>  	struct slab *slabp;
>  	struct kmem_list3 *l3;
>  	const char *name;
> 
> 

