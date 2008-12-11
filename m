Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYLKDpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYLKDpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 22:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYLKDpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 22:45:25 -0500
Received: from mx1.suse.de ([195.135.220.2]:56363 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYLKDpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 22:45:24 -0500
Date: Wed, 10 Dec 2008 19:31:05 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Zachary Amsden <zach@vmware.com>, Huang Ying <ying.huang@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <alokkataria1@gmail.com>, <bruno.premont@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
Message-ID: <20081211033105.GA31972@suse.de>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com> <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com> <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com> <49405CB6.6010006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49405CB6.6010006@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 04:20:06PM -0800, Yinghai Lu wrote:
> Zachary Amsden wrote:
> > On Tue, 2008-12-09 at 17:15 -0800, Yinghai Lu wrote:
> > 
> >> you can not move that late,
> >>
> >> parse_setup_data==>early_memremap==>__early_ioremap
> > 
> > How does this look?
> > 
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 9d5674f..4c381cb 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -794,6 +794,11 @@ void __init setup_arch(char **cmdline_p)
>  	printk(KERN_INFO "Command line: %s\n", boot_command_line);
>  #endif
>  
> +#ifdef CONFIG_VMI
> +	/* VMI may relocate the fixmap; do this before touching ioremap area */
> +	vmi_init();
> +#endif

Shouldn't the #ifdef not be needed here if the .h files are set up
properly for the vmi_init prototype?  Please try to keep them out of .c
files wherever possible.

thanks,

greg k-h
