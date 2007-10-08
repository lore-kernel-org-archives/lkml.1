Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXJHRPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXJHRPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXJHRPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:15:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49614 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbXJHRPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:15:32 -0400
Subject: Re: [PATCH]fix page release issue in filemap_fault
From: Peter Zijlstra <peterz@infradead.org>
To: Yan Zheng <yanzheng@21cn.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <3d0408630710080828h7ad160dbxf6cbd8513c1ad3e8@mail.gmail.com>
References: <3d0408630710080828h7ad160dbxf6cbd8513c1ad3e8@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 19:15:23 +0200
Message-Id: <1191863723.20745.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-08 at 23:28 +0800, Yan Zheng wrote:
> Hi all
> 
> find_lock_page increases page's usage count, we should decrease it
> before return VM_FAULT_SIGBUS
> 
> Signed-off-by: Yan Zheng<yanzheng@21cn.com>

Nice catch, .23 material?

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ----
> diff -ur linux-2.6.23-rc9/mm/filemap.c linux/mm/filemap.c
> --- linux-2.6.23-rc9/mm/filemap.c	2007-10-07 15:03:33.000000000 +0800
> +++ linux/mm/filemap.c	2007-10-08 23:14:39.000000000 +0800
> @@ -1388,6 +1388,7 @@
>  	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>  	if (unlikely(vmf->pgoff >= size)) {
>  		unlock_page(page);
> +		page_cache_release(page);
>  		goto outside_data_content;
>  	}

