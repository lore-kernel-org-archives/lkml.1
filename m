Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZETSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZETSXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZETSXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:23:16 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46501 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755445AbZETSXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:23:16 -0400
Date: Wed, 20 May 2009 14:23:00 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org,
       H Hartley Sweeten <hartleys@visionengravers.com>, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] mm/slub.c: Use print_hex_dump and remove unnecessary
 cast
In-Reply-To: <1242840314-25635-1-git-send-email-joe@perches.com>
Message-ID: <alpine.DEB.1.10.0905201420050.17511@qirst.com>
References: <1242840314-25635-1-git-send-email-joe@perches.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was discussed before.

http://lkml.indiana.edu/hypermail/linux/kernel/0705.3/2671.html

Was hexdump changed? How does the output look after this change?

On Wed, 20 May 2009, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  mm/slub.c |   34 ++++------------------------------
>  1 files changed, 4 insertions(+), 30 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 65ffda5..5b616d6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -328,36 +328,10 @@ static char *slub_debug_slabs;
>  /*
>   * Object debugging
>   */
> -static void print_section(char *text, u8 *addr, unsigned int length)
> +static void print_section(const char *text, u8 *addr, unsigned int length)
>  {
> -	int i, offset;
> -	int newline = 1;
> -	char ascii[17];
> -
> -	ascii[16] = 0;
> -
> -	for (i = 0; i < length; i++) {
> -		if (newline) {
> -			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
> -			newline = 0;
> -		}
> -		printk(KERN_CONT " %02x", addr[i]);
> -		offset = i % 16;
> -		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
> -		if (offset == 15) {
> -			printk(KERN_CONT " %s\n", ascii);
> -			newline = 1;
> -		}
> -	}
> -	if (!newline) {
> -		i %= 16;
> -		while (i < 16) {
> -			printk(KERN_CONT "   ");
> -			ascii[i] = ' ';
> -			i++;
> -		}
> -		printk(KERN_CONT " %s\n", ascii);
> -	}
> +	print_hex_dump(KERN_ERR, text, DUMP_PREFIX_ADDRESS, 16, 1,
> +		       addr, length, true);
>  }
>
>  static struct track *get_track(struct kmem_cache *s, void *object,
> @@ -794,7 +768,7 @@ static void trace(struct kmem_cache *s, struct page *page, void *object,
>  			page->freelist);
>
>  		if (!alloc)
> -			print_section("Object", (void *)object, s->objsize);
> +			print_section("Object", object, s->objsize);
>
>  		dump_stack();
>  	}
>
