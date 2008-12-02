Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYLBWG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYLBWG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYLBWGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:06:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbYLBWGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:06:18 -0500
Date: Tue, 2 Dec 2008 14:05:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sm501: unsigned ptr cannot be negative
Message-Id: <20081202140537.c76e2b6a.akpm@linux-foundation.org>
In-Reply-To: <49312C40.3080909@gmail.com>
References: <49312C40.3080909@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 06:49:20 -0500
roel kluin <roel.kluin@gmail.com> wrote:

> unsigned ptr cannot be negative
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
> index f94ae84..dcd9879 100644
> --- a/drivers/video/sm501fb.c
> +++ b/drivers/video/sm501fb.c
> @@ -159,6 +159,9 @@ static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
>  		break;
>  
>  	case SM501_MEMF_PANEL:
> +		if (size > inf->fbmem_len)
> +			return -ENOMEM;
> +
>  		ptr = inf->fbmem_len - size;
>  		fbi = inf->fb[HEAD_CRT];
>  
> @@ -172,9 +175,6 @@ static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
>  		if (fbi && ptr < fbi->fix.smem_len)
>  			return -ENOMEM;
>  
> -		if (ptr < 0)
> -			return -ENOMEM;
> -
>  		break;
>  
>  	case SM501_MEMF_CRT:

Looks OK.

Also this:

	if (ptr > 0)
		ptr &= ~(PAGE_SIZE - 1);

could just be

	ptr = PAGE_ALIGN(ptr);					
