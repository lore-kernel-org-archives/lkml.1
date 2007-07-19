Return-Path: <linux-kernel-owner+w=401wt.eu-S934836AbXGSKeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934836AbXGSKeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938213AbXGSKW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:22:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43590 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938274AbXGSKWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:22:25 -0400
Date: Thu, 19 Jul 2007 11:21:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: kiran@scalex86.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [33/58] x86_64: Avoid too many remote cpu references due to /proc/stat
Message-ID: <20070719102149.GA7322@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <ak@suse.de>, kiran@scalex86.org, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095519.10E4C14E11@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719095519.10E4C14E11@wotan.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 11:55:19AM +0200, Andi Kleen wrote:
> 
> From: Ravikiran G Thirumalai <kiran@scalex86.org>
> Too many remote cpu references due to /proc/stat.
> 
> On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
> On every call to kstat_irqs, the process brings in per-cpu data from all
> online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
> results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
> /proc/stat is parsed by common commands like top, who etc, causing
> lots of cacheline transfers
> 
> This statistic seems useless. Other 'big iron' arches disable this.
> Can we disable computing/reporting this statistic?  This piece of
> statistic is not human readable on x86_64 anymore,
> 
> If not, can we optimize computing this statistic so as to avoid
> too many remote references (patch to follow)

If we disable this on x86_64 we should just kill it completely for consistency.

> -#if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64)
> +#if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64) \
> +					&& !defined(CONFIG_X86_64)
>  	for (i = 0; i < NR_IRQS; i++)
>  		seq_printf(p, " %u", kstat_irqs(i));
>  #endif
