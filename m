Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbXJXVJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbXJXVJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbXJXVJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:09:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819AbXJXVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:09:21 -0400
Date: Wed, 24 Oct 2007 14:08:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: penberg@cs.helsinki.fi, ezk@cs.sunysb.edu, ryan@finnie.org,
       mhalcrow@us.ibm.com, cjwatson@ubuntu.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE
Message-Id: <20071024140836.a0098180.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710242152020.13001@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
	<200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
	<84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
	<Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0710242152020.13001@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 22:02:15 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> --- 2.6.24-rc1/mm/shmem.c	2007-10-24 07:16:04.000000000 +0100
> +++ linux/mm/shmem.c	2007-10-24 20:24:31.000000000 +0100
> @@ -915,6 +915,11 @@ static int shmem_writepage(struct page *
>  	struct inode *inode;
>  
>  	BUG_ON(!PageLocked(page));
> +	if (!wbc->for_reclaim) {
> +		set_page_dirty(page);
> +		unlock_page(page);
> +		return 0;
> +	}
>  	BUG_ON(page_mapped(page));

Needs a comment, methinks.
