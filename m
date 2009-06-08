Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZFHQDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZFHQDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZFHQDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:03:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbZFHQD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:03:29 -0400
Date: Mon, 8 Jun 2009 18:03:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, UV: Fix nacros for multiple coherency domains
Message-ID: <20090608160324.GA4355@elte.hu>
References: <20090608154405.GA16395@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608154405.GA16395@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Fix bug in the SGI UV macros that support systems with multiple 
> coherency domains.  The macros used for referencing global MMR 
> (chipset registers) are failing to correctly "or" the NASID (node 
> identifier) bits that reside above M+N. These high bits are 
> supplied automatically by the chipset for memory accesses coming 
> from the processor socket. However, the bits must be present for 
> references to the special global MMR space used to map chipset 
> registers. (See uv_hub.h for more details ...)
> 
> The bug results in references to invalid/incorrect nodes.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
>  arch/x86/include/asm/uv/uv_hub.h   |    6 ++++--
>  arch/x86/kernel/apic/x2apic_uv_x.c |   15 +++++++++------
>  2 files changed, 13 insertions(+), 8 deletions(-)

Applied, thanks Jack. Note - this has missed .30 but i marked it for 
.30.1 backporting, because it obviously only affects UV code.

	Ingo
