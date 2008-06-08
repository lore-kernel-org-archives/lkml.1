Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYFHWCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYFHWCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 18:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYFHWCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 18:02:04 -0400
Received: from saeurebad.de ([85.214.36.134]:33144 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbYFHWCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 18:02:02 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
       anderson@redhat.com
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
References: <20080608134628.757299158@halley.suse.de>
	<20080608134629.743220278@halley.suse.de>
Date: Mon, 09 Jun 2008 00:01:15 +0200
In-Reply-To: <20080608134629.743220278@halley.suse.de> (Bernhard Walle's
	message of "Sun, 08 Jun 2008 15:46:30 +0200")
Message-ID: <87bq2bmvro.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bernhard Walle <bwalle@suse.de> writes:

> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -798,12 +798,13 @@ void free_initrd_mem(unsigned long start
>  }
>  #endif
>  
> -void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
> +int __init reserve_bootmem_generic(unsigned long phys, unsigned len, int flags)
>  {
>  #ifdef CONFIG_NUMA
>  	int nid, next_nid;
>  #endif
>  	unsigned long pfn = phys >> PAGE_SHIFT;
> +	int ret;
>  
>  	if (pfn >= end_pfn) {
>  		/*
> @@ -811,11 +812,11 @@ void __init reserve_bootmem_generic(unsi
>  		 * firmware tables:
>  		 */
>  		if (pfn < max_pfn_mapped)
> -			return;
> +			return -EFAULT;

This seemed to be `just do nothing' behaviour.  Wouldn't 0 be more
correct here?  Or something else so there is a difference between the
path that does not print a warning (the one below) and the path that
does?

>  
>  		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
>  				phys, len);
> -		return;
> +		return -EFAULT;
>  	}

	Hannes
