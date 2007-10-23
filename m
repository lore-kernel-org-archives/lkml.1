Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbXJWFgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbXJWFgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXJWFgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:36:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39975 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbXJWFgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:36:35 -0400
Date: Tue, 23 Oct 2007 14:35:01 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] Fix warning in mm/slub.c
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20071023042153.GA20693@lixom.net>
References: <20071018122345.514F.Y-GOTO@jp.fujitsu.com> <20071023042153.GA20693@lixom.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071023143212.8D2E.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> "Make kmem_cache_node for SLUB on memory online to avoid panic" introduced
> the following:
> 
> mm/slub.c:2737: warning: passing argument 1 of 'atomic_read' from
> incompatible pointer type
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index aac1dd3..bcdb2c8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2734,7 +2734,7 @@ static void slab_mem_offline_callback(void *arg)
>  			 * and offline_pages() function shoudn't call this
>  			 * callback. So, we must fail.
>  			 */
> -			BUG_ON(atomic_read(&n->nr_slabs));
> +			BUG_ON(atomic_long_read(&n->nr_slabs));
>  
>  			s->node[offline_node] = NULL;
>  			kmem_cache_free(kmalloc_caches, n);


Oops, yes. Thanks.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>



-- 
Yasunori Goto 


