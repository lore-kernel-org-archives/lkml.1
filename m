Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZHaMu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZHaMu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZHaMu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:50:59 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43665 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbZHaMu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:50:58 -0400
Date: Mon, 31 Aug 2009 07:50:59 -0500
From: Jack Steiner <steiner@sgi.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gru: allocation may fail in quicktest1()
Message-ID: <20090831125059.GA31874@sgi.com>
References: <4A9B8A8F.5020600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9B8A8F.5020600@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 10:32:15AM +0200, Roel Kluin wrote:
> The allocation may fail.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Jack Steiner <steiner@sgi.com>

> ---
> diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
> index 79689b1..766e21e 100644
> --- a/drivers/misc/sgi-gru/grukservices.c
> +++ b/drivers/misc/sgi-gru/grukservices.c
> @@ -937,6 +937,8 @@ static int quicktest1(unsigned long arg)
>  
>  	/* Need  1K cacheline aligned that does not cross page boundary */
>  	p = kmalloc(4096, 0);
> +	if (p == NULL)
> +		return -ENOMEM;
>  	mq = ALIGNUP(p, 1024);
>  	memset(mes, 0xee, sizeof(mes));
>  	dw = mq;
