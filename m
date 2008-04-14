Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYDNOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYDNOnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbYDNOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:42:51 -0400
Received: from ns2.mvista.com ([63.81.120.155]:62209 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758797AbYDNOmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:42:50 -0400
Message-ID: <48036D43.6070307@ru.mvista.com>
Date: Mon, 14 Apr 2008 18:42:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mtd/cmdlinepart.c: don't compare pointers with 0
References: <20080414142004.GR6695@cs181133002.pp.htv.fi>
In-Reply-To: <20080414142004.GR6695@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:

> Sparse spotted that 0 was compared to pointers.

> While I was at it, I also moved the assignments out of the if's.

> Signed-off-by: Adrian Bunk <bunk@kernel.org>

> 32de76e83f37322dd85eaecf126e7b17327f606f diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
> index b44292a..3e09043 100644
> --- a/drivers/mtd/cmdlinepart.c
> +++ b/drivers/mtd/cmdlinepart.c
> @@ -119,7 +119,8 @@ static struct mtd_partition * newpart(char *s,
>  		char *p;
>  
>  	    	name = ++s;
> -		if ((p = strchr(name, delim)) == 0)
> +		p = strchr(name, delim);
> +		if (!p)
>  		{

    Wouldn't it be nice to join the standalone brace to if () while it?

>  			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
>  			return NULL;

WBR, Sergei
