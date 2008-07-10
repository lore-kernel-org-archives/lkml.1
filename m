Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYGJINA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYGJINA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYGJIMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:12:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbYGJIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:12:24 -0400
Date: Thu, 10 Jul 2008 10:12:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: akataria@vmware.com, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
Message-ID: <20080710081206.GA4819@elte.hu>
References: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com> <20080709061336.GG9760@elte.hu> <86802c440807090020q516b6332qf8e0d65918e7001e@mail.gmail.com> <1215624603.3930.8.camel@alok-dev1> <86802c440807091038m6c14f165xede8b2b0316d0225@mail.gmail.com> <20080710072201.GE14377@elte.hu> <86802c440807100034w3a3ee192k8e565b75fd2df608@mail.gmail.com> <20080710075030.GA27361@elte.hu> <86802c440807100104s1e1f1cdeg421be2dbeffdcb75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807100104s1e1f1cdeg421be2dbeffdcb75@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> first round bisect all works..
> 
> it seems make oldconfig change setting between different setting...

yeah. The thing i do is this: i create a .config.bisect and at every 
bisection step i copy it into .config and do a 'make oldconfig'.

this means that options are picked up again, even if a 'dive back into 
the past' causes a bisection point to lose a config setting.

> 
> diff .config config.full.good
> 4c4
> < # Thu Jul 10 00:52:52 2008
> ---
> > # Thu Jul 10 00:40:03 2008
> 295,296c295
> < CONFIG_CC_STACKPROTECTOR_ALL=y
> < CONFIG_CC_STACKPROTECTOR=y
> ---
> > # CONFIG_CC_STACKPROTECTOR is not set
> 
> it seems some recent change doesn't like stackprotector.

then my guess would be on:

 89d7bb5: x86_64: add workaround for no %gs-based percpu

you might want to try your luck and revert that one alone from latest 
tip/master.

	Ingo
