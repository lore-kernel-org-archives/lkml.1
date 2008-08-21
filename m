Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYHUOGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYHUOGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYHUOGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:06:48 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:52981 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYHUOGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:06:47 -0400
Message-ID: <48AD7673.1030705@numericable.fr>
Date: Thu, 21 Aug 2008 16:06:43 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008081609)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re:[PATCH] x86-64: fix two modpost warnings in mm/init_64.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> early_io{re,un}map() are __init and hence can't be called from __meminit
> functions.
> Signed-off-by: Jan Beulich<jbeulich@novell.com>
>
> ---
>   arch/x86/mm/init_64.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> --- linux-2.6.27-rc4/arch/x86/mm/init_64.c	2008-08-21 15:02:41.000000000 +0200
> +++ 2.6.27-rc4-x86_64-modpost-mm-init/arch/x86/mm/init_64.c	2008-08-21 11:49:44.000000000 +0200
> @@ -241,7 +241,7 @@ static unsigned long __initdata table_st
>   static unsigned long __meminitdata table_end;
>   static unsigned long __meminitdata table_top;
>
> -static __meminit void *alloc_low_page(unsigned long *phys)
> +static __ref void *alloc_low_page(unsigned long *phys)
>   {
>   	unsigned long pfn = table_end++;
>   	void *adr;
> @@ -262,7 +262,7 @@ static __meminit void *alloc_low_page(un
>   	return adr;
>   }
>
> -static __meminit void unmap_low_page(void *adr)
> +static __ref void unmap_low_page(void *adr)
>   {
>   	if (after_bootmem)
>   		return;
>
>
>    
Hi Jan,

I have tested your patch, it works fine on my amd64 box and the three 
section mismatches in cause have desapparead.

Thanks and regards.

