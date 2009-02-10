Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZBJOO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZBJOO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZBJOOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:14:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43929 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZBJOOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:14:14 -0500
Date: Tue, 10 Feb 2009 15:14:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pengfei Hu <hpfei.cn@gmail.com>, Vegard Nossum <vegard.nossum@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Using module private memory to simulate microkernel's memory
	protection
Message-ID: <20090210141405.GA16147@elte.hu>
References: <a5f59d880902100542x7243b13fuf40e7dd21faf7d7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5f59d880902100542x7243b13fuf40e7dd21faf7d7a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pengfei Hu <hpfei.cn@gmail.com> wrote:

> diff -Nurp old/arch/x86/Kconfig.debug new/arch/x86/Kconfig.debug
> --- old/arch/x86/Kconfig.debug	2008-10-10 06:13:53.000000000 +0800
> +++ new/arch/x86/Kconfig.debug	2008-12-07 19:19:40.000000000 +0800
> @@ -67,6 +67,16 @@ config DEBUG_PAGEALLOC
>  	  This results in a large slowdown, but helps to find certain types
>  	  of memory corruptions.
> 
> +config DEBUG_KM_PROTECT
> +        bool "Debug kernel memory protect"
> +        depends on DEBUG_KERNEL
> +        select DEBUG_PAGEALLOC
> +        select SLUB
> +        help
> +          Change page table's present flag to prevent other module's accidental
> +          access. This results in a large slowdown and waste more memory, but
> +          helps to find certain types of memory corruptions.

Hm, are you aware of the kmemcheck project?

	Ingo
