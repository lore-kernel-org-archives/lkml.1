Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYJ0NSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYJ0NSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYJ0NRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:17:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYJ0NRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:17:51 -0400
Date: Mon, 27 Oct 2008 14:17:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] UV: memory allocation at initialization
Message-ID: <20081027131739.GE25371@elte.hu>
References: <E1Kt949-0000LU-0z@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kt949-0000LU-0z@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0054]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> UV initialization is currently called too late to call alloc_bootmem_pages().
> The current sequence is:
> 
>  start_kernel()
>    mem_init()
>      free_all_bootmem()           <--- discard of bootmem
>    rest_init()
>      kernel_init()
>        smp_prepare_cpus()
>        native_smp_prepare_cpus()
>          uv_system_init()         <--- uses alloc_bootmem_pages()
> 
> It should be calling kmalloc().
> 
> Diffed against 2.6.27 (linux-next)
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  arch/x86/kernel/genx2apic_uv_x.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

applied to tip/x86/urgent, thanks Cliff!

	Ingo
