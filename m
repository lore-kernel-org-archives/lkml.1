Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYH2OI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYH2OI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYH2OIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:08:20 -0400
Received: from gw.goop.org ([64.81.55.164]:50065 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbYH2OIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:08:20 -0400
Message-ID: <48B802D2.5050501@goop.org>
Date: Fri, 29 Aug 2008 07:08:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org>  <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>  <48B76CE0.5010309@goop.org>  <20080829102547.655440bf@lxorguk.ukuu.org.uk> <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com> <Pine.LNX.4.64.0808291120540.8561@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808291120540.8561@blonde.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Not quite the output we were expecting!  I've not got around to trying
> it yet, so beware, but I think Jeremy's patch needs the following on top.
> Or you may prefer to wait until one of us reports that it is now working
> as intended.
>
> --- a/arch/x86/kernel/setup.c	2008-08-29 11:17:16.000000000 +0100
> +++ b/arch/x86/kernel/setup.c	2008-08-29 11:19:24.000000000 +0100
> @@ -636,11 +636,12 @@ void check_for_bios_corruption(void)
>  		unsigned long *addr = __va(scan_areas[i].addr);
>  		unsigned long size = scan_areas[i].size;
>  
> -		for(; size; addr++, size--) {
> +		for(; size; addr++, size -= sizeof(unsigned long)) {
>   

Oops, yes.

>  			if (!*addr)
>  				continue;
>  			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
>  			       addr, __pa(addr), *addr);
> +			*addr = 0;
>   

Good idea.

>  			corruption = 1;
>  		}
>  	}


    J
