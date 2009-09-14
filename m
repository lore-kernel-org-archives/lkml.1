Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZIND0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZIND0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZIND0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZIND0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:26:16 -0400
Subject: Re: [GIT BISECT] BUG kmalloc-8192: Object already free from
 kmem_cache_destroy
From: Eric Paris <eparis@redhat.com>
To: Danny Feng <dfeng@redhat.com>
Cc: cl@linux-foundation.org, penberg@cs.helsinki.fi, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <4AADB5EE.9090902@redhat.com>
References: <1252866835.13780.37.camel@dhcp231-106.rdu.redhat.com>
	 <4AADB5EE.9090902@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Sep 2009 23:25:39 -0400
Message-Id: <1252898739.5793.4.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 11:18 +0800, Danny Feng wrote:
> diff --git a/mm/slub.c b/mm/slub.c
> index b627675..40e12d5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3337,8 +3337,8 @@ struct kmem_cache *kmem_cache_create(const char
> *name, size_t size,
>                                 goto err;
>                         }
>                         return s;
> -               }
> -               kfree(s);
> +               } else
> +                       kfree(s);
>         }
>         up_write(&slub_lock);
>   

Doesn't the return inside the conditional take care of this?  I'll give
it a try in the morning, but I don't see how this can solve the
problem....

-Eric

