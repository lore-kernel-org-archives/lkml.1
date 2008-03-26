Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYCZGlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYCZGlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYCZGlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:41:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbYCZGlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:41:00 -0400
Date: Wed, 26 Mar 2008 07:40:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 01/10] x86_64: Cleanup non-smp usage of cpu maps v2
Message-ID: <20080326064045.GF18301@elte.hu>
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.011213000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325220651.011213000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Cleanup references to the early cpu maps for the non-SMP configuration 
> and remove some functions called for SMP configurations only.

thanks, applied.

one observation:

> +#ifdef CONFIG_SMP
>  extern int x86_cpu_to_node_map_init[];
>  extern void *x86_cpu_to_node_map_early_ptr;
> +#else
> +#define x86_cpu_to_node_map_early_ptr NULL
> +#endif

Right now all these early_ptrs are in essence open-coded "early 
per-cpu", right? But shouldnt we solve that in a much cleaner way: by 
explicitly adding an early-per-cpu types and accessors, and avoid all 
that #ifdeffery?

	Ingo
