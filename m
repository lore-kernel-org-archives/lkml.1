Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYCKJKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYCKJKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYCKJKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:10:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40053 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYCKJKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:10:06 -0400
Date: Tue, 11 Mar 2008 10:09:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 Fix test_poke for vmalloced pages
Message-ID: <20080311090947.GG25110@elte.hu>
References: <20080310183653.GA4482@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310183653.GA4482@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> The shadow vmap for DEBUG_RODATA kernel text modification uses 
> virt_to_page to get the pages from the pointer address.
> 
> However, I think vmalloc_to_page would be required in case the page is 
> used for modules.
> 
> Since only the core kernel text is marked read-only, use 
> kernel_text_address() to make sure we only shadow map the core kernel 
> text, not modules.

actually, i think we should mark module text readonly too.

	Ingo
