Return-Path: <linux-kernel-owner+w=401wt.eu-S934775AbXKPVhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775AbXKPVhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbXKPVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:37:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757426AbXKPVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:37:35 -0500
Date: Fri, 16 Nov 2007 13:37:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, clameter@sgi.com,
       linux-mm@kvack.org
Subject: Re: [Patch] mm/sparse.c: Check the return value of
 sparse_index_alloc().
Message-Id: <20071116133714.876f5246.akpm@linux-foundation.org>
In-Reply-To: <20071115135428.GE2489@hacking>
References: <20071115135428.GE2489@hacking>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 21:54:28 +0800
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> 
> Since sparse_index_alloc() can return NULL on memory allocation failure,
> we must deal with the failure condition when calling it.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Rik van Riel <riel@redhat.com>
> 
> ---
> 
> diff --git a/Makefile b/Makefile
> diff --git a/mm/sparse.c b/mm/sparse.c
> index e06f514..d245e59 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -83,6 +83,8 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  		return -EEXIST;
>  
>  	section = sparse_index_alloc(nid);
> +	if (!section)
> +		return -ENOMEM;
>  	/*
>  	 * This lock keeps two different sections from
>  	 * reallocating for the same index

Sure, but both callers of sparse_index_init() ignore its return value anyway.
