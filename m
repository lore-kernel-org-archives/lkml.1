Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbZJLTfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbZJLTfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933167AbZJLTfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:35:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145AbZJLTfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:35:15 -0400
Date: Mon, 12 Oct 2009 21:34:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Fix irq affinity for hub based interrupts
Message-ID: <20091012193433.GB2691@elte.hu>
References: <20090930160259.GA7822@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930160259.GA7822@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> This patch fixes handling of uv hub irq affinity.  IRQs with ALL or
> NODE affinity can be routed to cpus other than their originally assigned
> cpu.  Those with CPU affinity cannot be rerouted.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> More specific handling for NODE affinity will be added once the patch for
> limiting irq affinity is in place.
> 
>  arch/x86/include/asm/uv/uv_irq.h |   15 +++-
>  arch/x86/kernel/apic/io_apic.c   |   49 ++++++++++++-

Could we please move all these UV specific functions out of the generic 
IO-APIC code? You can do it as a followup patch to this one, but i'd 
like to see the end result first before applying these - the interfacing 
is rather messy right now.

	Ingo
