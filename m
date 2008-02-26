Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYBZHfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYBZHfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbYBZHfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:35:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbYBZHfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:35:03 -0500
Date: Tue, 26 Feb 2008 08:34:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for
	intel cpu
Message-ID: <20080226073444.GG24820@elte.hu>
References: <200802252320.01534.yinghai.lu@sun.com> <20080226072035.GB24820@elte.hu> <86802c440802252324u769f087fw83caa26c1960354e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802252324u769f087fw83caa26c1960354e@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >   #define set_cpu_cap(c, bit)     set_bit(bit, (unsigned long *)((c)->x86_capability)
> >
> >  which is the same. set_cpu_cap() is indeed the cleaner form to do this
> >  so your patch is correct as a cleanup.
> set_cpu_cap is right
> ==
> set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability); ===> is wrong
> should be
> set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
> 
> x86_capability is a array ...
> 
> so this could prevent some data corruption.

ah, right you are! The commit was done in a sloppy, incomplete way, 
leaving around lots of direct c->x86_capability references and giving 
room for this bug ...

Btw., there's one other place that has the same bug. I'll fix that up 
too.

	Ingo
