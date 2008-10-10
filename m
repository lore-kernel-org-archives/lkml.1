Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbYJJJBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbYJJJBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYJJJBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:01:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbYJJJBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:01:18 -0400
Date: Fri, 10 Oct 2008 11:01:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Message-ID: <20081010090100.GC319@elte.hu>
References: <20081010002203.GA23238@linux-os.sc.intel.com> <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com> <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Ah, it was CONFG who is guilty :) This is true indeed, thanks!

yeah.

> But here is not the same
> 
>        apic_write(APIC_TDCR,
>                (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
> -               APIC_TDR_DIV_16);
> +               APIC_TDR_DIV);
> 
> On x86_64 it will be 1 now but we've used 16 for a long time in 
> purpose to slowdown processor's bus CLKs from APIC point of view. So I 
> don't think it's good idea to change it now. If we start using divisor 
> 1 today -- it would work for some time 'till processor bus raised to 
> the some speed when we'll get counter underflow before calibration 
> finished.
> 
> So could you please split the patch into two:
> 1) Plain CONFG typo fix (which is completely Ack'ed)
> 2) APIC divisor patch (which I'm not sure if we've to touch)

okay, since we typoed that CONFG thing (sidenote: we really need a 
.config flag that will start a grep that fails the build if there's a 
non-existent CONFIG option anywhere in the tree), we basically tested 
the divisor of 16 on a wide range of boxes.

So .. how about just standardizing on the divisor of 16 on both 32-bit 
and 64-bit?

	Ingo
