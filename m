Return-Path: <linux-kernel-owner+w=401wt.eu-S1423526AbXEANtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423526AbXEANtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423533AbXEANtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:49:31 -0400
Received: from rtr.ca ([64.26.128.89]:3644 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423526AbXEANta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:49:30 -0400
Message-ID: <46374566.90003@rtr.ca>
Date: Tue, 01 May 2007 09:49:26 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>, Andi Kleen <ak@suse.de>,
       Eric Dumazet <dada1@cosmosbay.com>, ebiederm@xmission.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the
 2G/2G split.
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <4636C16F.204@cosmosbay.com> <20070501062132.GQ25929@bingen.suse.de> <20070501130132.GL26598@holomorphy.com>
In-Reply-To: <20070501130132.GL26598@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
>
> I don't mind so long as we're not letting doorstop configs through. I'd
> probably do something more like
> 
> Index: sched/arch/i386/Kconfig
> ===================================================================
> --- sched.orig/arch/i386/Kconfig	2007-05-01 04:35:47.065162310 -0700
> +++ sched/arch/i386/Kconfig	2007-05-01 04:36:50.100754504 -0700
> @@ -571,6 +571,9 @@
>  		bool "3G/1G user/kernel split (for full 1G low memory)"
>  	config VMSPLIT_2G
>  		bool "2G/2G user/kernel split"
> +	config VMSPLIT_2G_OPT
> +		depends on !HIGHMEM
> +		bool "2G/2G user/kernel split (for full 2G low memory)"
>  	config VMSPLIT_1G
>  		bool "1G/3G user/kernel split"
>  endchoice
> @@ -578,7 +581,8 @@
>  config PAGE_OFFSET
>  	hex
>  	default 0xB0000000 if VMSPLIT_3G_OPT
> -	default 0x78000000 if VMSPLIT_2G
> +	default 0x80000000 if VMSPLIT_2G
> +	default 0x78000000 if VMSPLIT_2G_OPT
>  	default 0x40000000 if VMSPLIT_1G
>  	default 0xC0000000
>  
> as a stopgap measure, but I'm not all that interested in grabbing patch
..

Yup, I second that one.  The idea of the original 2G split
was to avoid the need for HIGHMEM entirely, reducing overhead
on slower machines.

Having both kinds of splits is fine, but probably just the original one
with the !PAE is okay too.

-ml
