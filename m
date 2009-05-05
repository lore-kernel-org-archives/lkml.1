Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZEEMcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZEEMcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZEEMco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:32:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:38520 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZEEMcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:32:43 -0400
Date: Tue, 5 May 2009 14:32:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "figo.zhang" <figo.zhang@kolorific.com>
Cc: rdunlap@xenotime.net, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH][RESEND]Documentation/rbtree.txt: cleanup kerneldoc of
 rbtree.txt
In-Reply-To: <1239937128.3355.11.camel@myhost>
Message-ID: <alpine.LNX.2.00.0905051431400.22532@wotan.suse.de>
References: <1239937128.3355.11.camel@myhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, figo.zhang wrote:

>  The first formal parameter of the rb_link_node() is a pointer, and the
>  "node" is define a data struct (pls see line 67 and line 73 in the
>  doc), so the actual parameter should use "&data->node".
> 
> Signed-off-by: Figo.zhang <figo.zhang@kolorific.com>
> ---
>  Documentation/rbtree.txt |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
> index 7224459..7710214 100644
> --- a/Documentation/rbtree.txt
> +++ b/Documentation/rbtree.txt
> @@ -131,8 +131,8 @@ Example:
>    	}
>  
>    	/* Add new node and rebalance tree. */
> -  	rb_link_node(data->node, parent, new);
> -  	rb_insert_color(data->node, root);
> +  	rb_link_node(&data->node, parent, new);
> +  	rb_insert_color(&data->node, root);
>  
>  	return TRUE;
>    }
> @@ -146,10 +146,10 @@ To remove an existing node from a tree, call:
>  
>  Example:
>  
> -  struct mytype *data = mysearch(mytree, "walrus");
> +  struct mytype *data = mysearch(&mytree, "walrus");
>  
>    if (data) {
> -  	rb_erase(data->node, mytree);
> +  	rb_erase(&data->node, &mytree);
>    	myfree(data);
>    }
>  

Didn't find it in today's linux-next pileup, so I have applied it to 
trivial tree. Thanks,

-- 
Jiri Kosina
SUSE Labs
