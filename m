Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYIVId5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYIVId5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYIVIdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:33:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYIVIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:33:48 -0400
Date: Mon, 22 Sep 2008 01:33:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krishna Kumar <krkumar2@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do_generic_file_read() never gets a NULL 'filp'
 argument
Message-Id: <20080922013338.8e1c10ff.akpm@linux-foundation.org>
In-Reply-To: <20080922061610.20158.86022.sendpatchset@localhost.localdomain>
References: <20080922061610.20158.86022.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 11:46:10 +0530 Krishna Kumar <krkumar2@in.ibm.com> wrote:

> From: Krishna Kumar <krkumar2@in.ibm.com>
> 
> The 'filp' argument to do_generic_file_read() is never NULL.
> 

How did you verify this?

NFS used to like passing NULL file*'s into VFS functions.  I don't
recall whether it affected do_generic_file_read().

>  mm/filemap.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -ruNp 2.6.27-rc7-org/mm/filemap.c 2.6.27-rc7-new/mm/filemap.c
> --- 2.6.27-rc7-org/mm/filemap.c	2008-09-17 12:53:25.000000000 +0530
> +++ 2.6.27-rc7-new/mm/filemap.c	2008-09-17 12:53:59.000000000 +0530
> @@ -1186,8 +1186,7 @@ out:
>  	ra->prev_pos |= prev_offset;
>  
>  	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
> -	if (filp)
> -		file_accessed(filp);
> +	file_accessed(filp);
>  }
>  
>  int file_read_actor(read_descriptor_t *desc, struct page *page,
