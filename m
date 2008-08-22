Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYHVPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYHVPhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYHVPhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:37:37 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:17943 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYHVPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:37:37 -0400
Message-ID: <48AEDD3D.4060507@hp.com>
Date: Fri, 22 Aug 2008 11:37:33 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <48A36838.3050309@hp.com> <20080819124602.9e8e69f7.akpm@linux-foundation.org>
In-Reply-To: <20080819124602.9e8e69f7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> 
> You could confirm/debug it with something along the lines of this:
> 
> --- a/mm/vmalloc.c~a
> +++ a/mm/vmalloc.c
> @@ -214,7 +214,9 @@ __get_vm_area_node(unsigned long size, u
>  	unsigned long align = 1;
>  	unsigned long addr;
>  
> -	BUG_ON(in_interrupt());
> +	if (preempt_count() > 10)
> +		printk("%s: preempt_count()=%d\n", __func__, preempt_count());
> +	WARN_ON(in_interrupt());
>  	if (flags & VM_IOREMAP) {
>  		int bit = fls(size);
>  
> _
> 
> 
> But this bug could be in practically anywhere in the kernel and
> bisection is by far the best way to find it.  It's sad and odd that
> bisection landed you on a merge commit.  I'd suggest that you persist
> with the bisection (please). 
> http://www.kernel.org/doc/local/git-quick.html#example might be useful.

Sorry, was off on other things for the last couple of days:

I /did/ bisect it down to the aforementioned merge, the question is: How
to crack open that merge into it's composite pieces? (Where do I go to
bisect within that?)

I'll try the patch above, and see what that reports.

Alan
