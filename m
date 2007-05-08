Return-Path: <linux-kernel-owner+w=401wt.eu-S967407AbXEHL7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967407AbXEHL7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967335AbXEHL7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:59:20 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:47571 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967360AbXEHL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:59:19 -0400
Message-ID: <46406595.2000205@yahoo.fr>
Date: Tue, 08 May 2007 13:57:09 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 010/455] block_write_full_page(): report ENOSPC
References: <200705080723.l487NR1v016370@shell0.pdx.osdl.net>
In-Reply-To: <200705080723.l487NR1v016370@shell0.pdx.osdl.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org a écrit :
> block_write_full_page() forgot to propagate ENPSOC into the address_space.

> --- a/fs/buffer.c~block_write_full_page-handle-enospc
> +++ a/fs/buffer.c
> @@ -1727,6 +1727,7 @@ recover:
>  	} while ((bh = bh->b_this_page) != head);
>  	SetPageError(page);
>  	BUG_ON(PageWriteback(page));
> +	mapping_set_error(page->mapping, err);
>  	set_page_writeback(page);
>  	do {
>  		struct buffer_head *next = bh->b_this_page;

As I said in http://lkml.org/lkml/2007/2/9/336 I am not aware of any 
call stack where the error is dropped here.

So, this patch should not harm but I am not sure it does any good.

Thanks.

-- 
Guillaume
