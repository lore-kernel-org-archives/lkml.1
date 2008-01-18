Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYARJMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYARJMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbYARJMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:12:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56339 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbYARJMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:12:23 -0500
Date: Fri, 18 Jan 2008 10:12:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] x86: Use v8086_mode helper, trivial unification
Message-ID: <20080118091208.GE24337@elte.hu>
References: <1200615957.5724.75.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200615957.5724.75.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use v8086_mode inline in fault_32.c, no functional change also ifdef 
> the section for 32-bit only and add to fault_64.c

> -	if (regs->flags & VM_MASK) {
> +	if (v8086_mode(regs)) {

> --- a/arch/x86/mm/fault_64.c
> +++ b/arch/x86/mm/fault_64.c
> @@ -551,6 +551,16 @@ good_area:
>  		tsk->maj_flt++;
>  	else
>  		tsk->min_flt++;
> +
> +	/*
> +	 * Did it hit the DOS screen memory VA from vm86 mode?
> +	 */
> +	if (v8086_mode(regs)) {
> +		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
> +		if (bit < 32)
> +			tsk->thread.screen_bitmap |= 1 << bit;
> +	}

hm, is there even vm86 mode in 64-bit? Anyway, gcc will eliminate it i 
guess. I've applied your patch.

	Ingo
