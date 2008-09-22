Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbYIVFct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbYIVFct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 01:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYIVFcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 01:32:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59634 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYIVFck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 01:32:40 -0400
Date: Mon, 22 Sep 2008 14:32:17 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Krishna Kumar <krkumar2@in.ibm.com>
Subject: Re: [PATCH] mm: do_generic_file_read() doesn't need to validate filp
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080922040325.10196.87900.sendpatchset@localhost.localdomain>
References: <20080922040325.10196.87900.sendpatchset@localhost.localdomain>
Message-Id: <20080922143017.F3F1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Please write explictly that filp is never passed NULL for patch description clarify.
Otherthing, looks good to me.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> From: Krishna Kumar <krkumar2@in.ibm.com>
> 
> do_generic_file_read() doesn't need to validate filp when accessing it. This
> is probably a remnant of an earlier code.
> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> ---
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



