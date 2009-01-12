Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZALScQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZALScQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZALSb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:31:59 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57237 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758AbZALSb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:31:59 -0500
Message-ID: <496B8C9A.5000905@sgi.com>
Date: Mon, 12 Jan 2009 10:31:54 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use nr_cpus in max_nr_irqs()
References: <496AD895.10701@kernel.org>
In-Reply-To: <496AD895.10701@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: get more small nr_irqs
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/apicdef.h     |    7 +------
>  arch/x86/include/asm/irq_vectors.h |    4 ++--
>  2 files changed, 3 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
> +++ linux-2.6/arch/x86/include/asm/irq_vectors.h
> @@ -122,8 +122,8 @@
>  
>  /* defined as a macro so nr_irqs = max_nr_irqs(nr_cpu_ids) can be used */
>  # define max_nr_irqs(nr_cpus)				\
> -	((8 * nr_cpus) > (32 * MAX_IO_APICS) ?		\
> -		(NR_VECTORS + (8 * NR_CPUS)) :		\
> +	((8 * (nr_cpus)) > (32 * MAX_IO_APICS) ?		\
> +		(NR_VECTORS + (8 * (nr_cpus)) :		\
>  		(NR_VECTORS + (32 * MAX_IO_APICS)))	\
>  
>  # define NR_IRQS max_nr_irqs(NR_CPUS)

Did I really miss that?  I guess the reduction from 33024 to 4352
was sufficient for me... ;-)

Hey, a question... Can I determine what the maximum apic id would be?
Right now it's fixed at 32k but that seems high even for 4096 cpus?
(MAX_APICS].

Thanks!
Mike

