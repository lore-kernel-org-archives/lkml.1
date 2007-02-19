Return-Path: <linux-kernel-owner+w=401wt.eu-S965141AbXBSWqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141AbXBSWqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965143AbXBSWqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:46:40 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:7035 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965141AbXBSWqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:46:39 -0500
Date: Mon, 19 Feb 2007 14:45:28 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH]: Change sysenter_setup to __cpuinit & improve __INIT,
 __INITDATA
In-reply-to: <20070219205012.13934.82952.sendpatchset@prarit.boston.redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Message-id: <Pine.LNX.4.64.0702191409470.32172@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20070219205012.13934.82952.sendpatchset@prarit.boston.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Prarit Bhargava wrote:

>  /* For assembly routines */
> +#ifdef CONFIG_HOTPLUG_CPU
> +#define __INIT		.section	".text","ax"
> +#define __INITDATA	.section	".data","aw"
> +#else
>  #define __INIT		.section	".init.text","ax"
> -#define __FINIT		.previous
>  #define __INITDATA	.section	".init.data","aw"
> +#endif
> +#define __FINIT		.previous
>  
>  #ifndef __ASSEMBLY__

Shouldn't this be __CPUINT/__CPUINITDATA? That way you could also get rid 
of things like in x86_64 head.S;

#ifndef CONFIG_HOTPLUG_CPU
        __INITDATA
#endif
