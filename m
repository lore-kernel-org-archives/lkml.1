Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYKXW1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYKXW1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYKXW1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:27:09 -0500
Received: from www.tglx.de ([62.245.132.106]:38013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYKXW1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:27:08 -0500
Date: Mon, 24 Nov 2008 23:26:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] irq: sparseirq enabling
In-Reply-To: <492AFEF9.609@kernel.org>
Message-ID: <alpine.LFD.2.00.0811242318490.3235@localhost.localdomain>
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492AFEF9.609@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Yinghai Lu wrote:
> Ingo Molnar wrote:
> > This should simplify quite a few things in the sparseirq code.
> 
> ok, will change to that. 
> 
> 1. nr_irqs will be legacy number or GSI numbers. MSI will start to use irq nr from nr_irqs
> 2. or MSI still to use irq from NR_IRQS - 1, and ... go smaller?

We should go up from legacy/GSI. We can decode the max. number of
possible "wired" irqs from the number of IO_APICs. Everything above
that is "virtual MSI" space.

Going down just makes it harder to read (numbers have more
digits for no value).

Thanks,

	tglx
