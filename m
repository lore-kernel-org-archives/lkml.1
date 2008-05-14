Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYENLoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYENLoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbYENLoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:44:06 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:35521 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbYENLoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:44:05 -0400
Message-ID: <482AD08D.7070206@grupopie.com>
Date: Wed, 14 May 2008 12:44:13 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kallsyms: fix potential overflow in binary search
References: <20080513200736.GA17909@damson.getinternet.no>
In-Reply-To: <20080513200736.GA17909@damson.getinternet.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
>>From 61b840f071e496f632fcc293f5435428cfc98844 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Tue, 13 May 2008 10:20:27 +0200
> Subject: [PATCH] kallsyms: fix potential overflow in binary search
> 
> This will probably never trigger... but it won't hurt to be careful.

Not "probably", this will never trigger _period_. If you ever have more 
than 2^31 symbols in the kernel's kallsyms table you'll have worse 
problems to worry about than the binary search overflowing.

So, I don't think it is worth this des-optimization at all...

> http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  kernel/kallsyms.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 6fc0040..38fc10a 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -176,7 +176,7 @@ static unsigned long get_symbol_pos(unsigned long addr,
>  	high = kallsyms_num_syms;
>  
>  	while (high - low > 1) {
> -		mid = (low + high) / 2;
> +		mid = low + (high - low) / 2;
>  		if (kallsyms_addresses[mid] <= addr)
>  			low = mid;
>  		else


-- 
Paulo Marques - www.grupopie.com

Dear aunt, let's set so double the killer delete select all.
-- Microsoft voice recognition live demonstration
