Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYIMVJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYIMVJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 17:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYIMVJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 17:09:40 -0400
Received: from gw.goop.org ([64.81.55.164]:46406 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbYIMVJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 17:09:40 -0400
Message-ID: <48CC2C12.4080302@goop.org>
Date: Sat, 13 Sep 2008 14:09:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: roberto@unbit.it
CC: jeremy@xensource.com, linux-kernel@vger.kernel.org,
       Mirko Iannella <mirko@unbit.it>, Ingo Molnar <mingo@elte.hu>,
       Alex Nixon <alex.nixon@citrix.com>
Subject: Re: Fix for xen guest with mem > 3.7G
References: <1221333418.6036.9.camel@sirius>
In-Reply-To: <1221333418.6036.9.camel@sirius>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto De Ioris wrote:
> Xen domU kernel 2.6.26 and 2.6.27-rc cannot allocate
> more than 3.7GB of ram on my PAE systems (compiled
> with gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)).
>
> I have found the problem is in function xen_memory_setup (in
> arch/x86/xen/setup.c).
>
> It set max_pfn as 'unsigned long' but add_memory_region()
> takes 'unsigned long long'.
>
> I do not know if it is a compiler problem but this is the simple fix
> (works on my systems):
>   

Thanks very much for the patch.  We have a more general fix for this in
Ingo's tip.git tree, but I overlooked that this particular problem
affected current -rc.

Ingo, this is fixed by the phys_addr_t + PFN_PHYS() patches.  Should we
send them up to Linus, or do an ad-hoc fix in this one place?

Thanks,
    J

> --- setup.c.orig	2008-09-13 21:12:56.000000000 +0200
> +++ setup.c	2008-09-13 20:35:29.000000000 +0200
> @@ -36,7 +36,7 @@
>  
>  char * __init xen_memory_setup(void)
>  {
> -	unsigned long max_pfn = xen_start_info->nr_pages;
> +	unsigned long long max_pfn = xen_start_info->nr_pages;
>  
>  	e820.nr_map = 0;
>  	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
>
>
>
>   

