Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYAIBQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYAIBQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYAIBQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:16:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYAIBQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:16:23 -0500
Date: Wed, 9 Jan 2008 02:16:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109011609.GB29807@elte.hu>
References: <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <20080109004329.GA6603@elte.hu> <47841EB1.1020304@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47841EB1.1020304@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This isn't correct, because it will set _PAGE_GLOBAL on 32-bit 
> unconditionally.  It needs to be something like:

hm, why is that a problem? Ah, the VDSO page must not be global-mapped, 
right? It's getting late here, i should stop modifying the kernel ;)

> +#define GLOBAL_PGPROT(prot)	__pgprot(prot | _PAGE_GLOBAL)
> +
> +#define PAGE_KERNEL			GLOBAL_PGPROT(__PAGE_KERNEL)
> +#define PAGE_KERNEL_RO			GLOBAL_PGPROT(__PAGE_KERNEL_RO)
> +#define PAGE_KERNEL_EXEC		GLOBAL_PGPROT(__PAGE_KERNEL_EXEC)
> +#define PAGE_KERNEL_RX			GLOBAL_PGPROT(__PAGE_KERNEL_RX)
> +#define PAGE_KERNEL_NOCACHE		GLOBAL_PGPROT(__PAGE_KERNEL_NOCACHE)
> +#define PAGE_KERNEL_LARGE		GLOBAL_PGPROT(__PAGE_KERNEL_LARGE)
> +#define PAGE_KERNEL_LARGE_EXEC		GLOBAL_PGPROT(__PAGE_KERNEL_LARGE_EXEC)
> +#define PAGE_KERNEL_VSYSCALL		GLOBAL_PGPROT(__PAGE_KERNEL_VSYSCALL)
> +#define PAGE_KERNEL_VSYSCALL_NOCACHE	GLOBAL_PGPROT(__PAGE_KERNEL_VSYSCALL_NOCACHE)

i suspect you wanted to make GLOBAL_PGPROT a NOP on 32-bit?

but i think it would be better to just do this distinction for the 
PAGE_KERNEL_VSYSCALL?

	Ingo
