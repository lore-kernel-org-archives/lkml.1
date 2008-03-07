Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYCGIl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYCGIl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYCGIlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:41:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40450 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbYCGIlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:41:00 -0500
Date: Fri, 7 Mar 2008 09:40:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: tight online check in setup_per_cpu_areas
Message-ID: <20080307084047.GE12150@elte.hu>
References: <86802c440803061825p5df1cdb7q9655da509ce3ce4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803061825p5df1cdb7q9655da509ce3ce4a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] x86_64: tight online check in setup_per_cpu_areas
> 
> when numa disabled got compile warning:
> arch/x86/kernel/setup64.c: In function ???setup_per_cpu_areas???:
> arch/x86/kernel/setup64.c:147: warning: the address of ???contig_page_data??? will always evaluate as ???true???
> 
> it seems we missed checking if the node is online before we try to 
> refer NODE_DATA. so fix it

thanks, applied.

> +#ifndef CONFIG_NEED_MULTIPLE_NODES
> +		ptr = alloc_bootmem_pages(size);
> +#else
> +		int node = early_cpu_to_node(i);
>  
> +		if (!node_online(node) || !NODE_DATA(node))
>  			ptr = alloc_bootmem_pages(size);
> +		else
> +			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
> +#endif

i'm wondering, shouldnt there just be a single facility for this mode of 
allocation, instead of this #ifdef and branch maze?

	Ingo
