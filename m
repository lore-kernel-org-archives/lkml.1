Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbYAaNH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbYAaNH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765563AbYAaNHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:07:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765098AbYAaNHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:07:46 -0500
Date: Thu, 31 Jan 2008 14:07:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PATCH] x86_64: make bootmap_start page align v4
Message-ID: <20080131130730.GA8499@elte.hu>
References: <200801291113.35974.yinghai.lu@sun.com> <200801291114.49030.yinghai.lu@sun.com> <200801291928.13927.yinghai.lu@sun.com> <200801301051.08485.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801301051.08485.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: make bootmap_start page align v3
> 
> boot oops when system get 64g or 128 installed

> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -224,6 +224,14 @@ void __init setup_node_bootmem(int nodei
>  	}
>  	bootmap_start = __pa(bootmap);
>  
> +	/*
> +	 * when you have 64g or 128g ram, bootmap will be pushed after bss
> +	 * section, the bootmap we get from early_node_mem via find_e820_area
> +	 * is not page aligned, we need to round it up to  make sure bootmap
> +	 * is not overlapped with bss section
> +	 */
> +	bootmap_start = round_up(bootmap_start, PAGE_SIZE);
> +

thanks, applied.

	Ingo
