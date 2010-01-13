Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167Ab0AMNQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0AMNQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674Ab0AMNQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:16:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:41593 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0AMNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:16:17 -0500
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1263387673-15231-1-git-send-email-acme@infradead.org>
References: <1263387673-15231-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 14:16:09 +0100
Message-ID: <1263388569.4244.215.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 11:01 -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Similar to list_for_each_entry, helps reducing boilerplate in many
> places and makes rbtrees closer to list.h macros.
> 
> First conversion will be in the tools/perf.

I'm still not sure you really want to do this, it might give people the
impression its a sane thing to do ;-)

> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  include/linux/rbtree.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
> index 9c29541..044b150 100644
> --- a/include/linux/rbtree.h
> +++ b/include/linux/rbtree.h
> @@ -158,4 +158,16 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>  	*rb_link = node;
>  }
>  
> +/**
> + * rb_for_each_entry - iterate over rbtree of given type
> + * @pos:	the type * to hold the current entry being traversed
> + * @node:	the rb_node to hold the current entry being traversed
> + * @root:	the root for your tree.
> + * @member:	the name of the rb_node within the struct.
> + */
> +#define rb_for_each_entry(pos, node, root, member)			\
> +	for (node = rb_first(root);					\
> +	     node && (pos = rb_entry(node, typeof(*pos), member));	\
> +	     node = rb_next(node))
> +
>  #endif	/* _LINUX_RBTREE_H */


