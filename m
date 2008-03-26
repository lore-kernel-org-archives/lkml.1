Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbYCZVYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbYCZVYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYCZVX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:23:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761984AbYCZVX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:23:26 -0400
Date: Wed, 26 Mar 2008 22:23:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
Message-ID: <20080326212312.GA27594@elte.hu>
References: <Pine.SGI.3.96.1080326161017.7873204a-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080326161017.7873204a-100000@fergus.americas.sgi.com>
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


* Alan Mayer <ajm@sgi.com> wrote:

> On machines with very large numbers of cpus, tables that are 
> dimensioned by NR_IRQS get very large, especially the irq_desc table.  
> They are also very sparsely used.  When the cpu count is > 
> MAX_IO_APICS, use MAX_IO_APICS to set NR_IRQS, otherwise use NR_CPUS.

thanks Alan, applied this in place of the other patch.

this bit is still ugly:

> -#define NR_IRQS (NR_VECTORS + (32 *NR_CPUS))
> +#if NR_CPUS < MAX_IO_APICS
> +#define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
> +#else
> +#define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
> +#endif
>  #define NR_IRQ_VECTORS NR_IRQS

but it doesnt really depart from the current status quo of huge 
[NR_IRQS] arrays either. Patches that make NR_IRQS a variable are 
welcome :)

	Ingo
