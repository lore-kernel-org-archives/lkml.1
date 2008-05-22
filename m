Return-Path: <linux-kernel-owner+w=401wt.eu-S936306AbYEVAVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936306AbYEVAVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761335AbYEVAVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:21:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760985AbYEVAVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:21:14 -0400
Date: Wed, 21 May 2008 17:20:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Divy Le Ray <divy@chelsio.com>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/3 2.6.27] cxgb3 - Add page support to jumbo frame Rx
 queue
Message-Id: <20080521172024.a1044aea.akpm@linux-foundation.org>
In-Reply-To: <20080521015737.6218.32204.stgit@speedy5>
References: <20080521015737.6218.32204.stgit@speedy5>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 18:57:37 -0700
Divy Le Ray <divy@chelsio.com> wrote:

> From: Divy Le Ray <divy@chelsio.com>
> 
> Add page support to Jumbo frame Rx queues.
> 
> ...
>
> @@ -460,7 +464,8 @@ nomem:				q->alloc_failed++;
>  			if (q->use_pages) {
>  				if (q->pg_chunk.page) {
>  					put_page(q->pg_chunk.page);
> -					__free_page(q->pg_chunk.page);
> +					__free_pages(q->pg_chunk.page,
> +						     q->order);
>  					q->pg_chunk.page =
>  						sd->pg_chunk.page = NULL;
>  				}

This hunk doesn't apply to 2.6.26-rc3, afacit.  The code it's patching
just isn't there.  But I think I fixed it up OK.

