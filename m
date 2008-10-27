Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJ0SGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJ0SGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYJ0SGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:06:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbYJ0SGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:06:39 -0400
Date: Mon, 27 Oct 2008 19:06:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI x86 UV: Update SCIR driver to use idle_cpu
	function
Message-ID: <20081027180616.GG3046@elte.hu>
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com> <49024B1D.1050407@sgi.com> <20081027114205.GB5631@elte.hu> <4905D568.20701@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4905D568.20701@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Subject: SGI x86 UV: Update SCIR driver to use idle_cpu function
> 
> > Please send the cpu_idle() cleanup patch separately.
> 
> Change UV heartbeat function to use idle_cpu to determine cpu's
> "idleness".  Realign uv_hub definitions.
> 
> Signed-of-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86/include/asm/uv/uv_hub.h |   26 +++++++++++++-------------
>  arch/x86/kernel/genx2apic_uv_x.c |    4 ++--
>  2 files changed, 15 insertions(+), 15 deletions(-)

applied to tip/x86/uv, thanks Mike!

one small comment:

> +	/* is this cpu idle? */
> +	if (idle_cpu(smp_processor_id()))
>  		bits &= ~SCIR_CPU_ACTIVITY;

were you ever to run an -rt kernel on that hardware, this would 
produce a warning. raw_smp_processor_id() would be more appropriate i 
guess.

	Ingo
