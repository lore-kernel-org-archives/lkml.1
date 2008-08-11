Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbYHKMU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbYHKMU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYHKMUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:20:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47163 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYHKMUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:20:49 -0400
Date: Mon, 11 Aug 2008 14:20:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@osdl.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811122038.GA10082@elte.hu>
References: <489C77C6.7040408@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489C77C6.7040408@keyaccess.nl>
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


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> Hi Andrew.
>
> <repeat below changelog>
>
> Rene.

> >From 00acea21e579ea0853baba25420f373ea83533a3 Mon Sep 17 00:00:00 2001
> From: Rene Herman <rene.herman@keyaccess.nl>
> Date: Thu, 7 Aug 2008 01:50:35 +0200
> Subject: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
> 
> commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly 
> nopped debugging printks in arch/x86/kernel/mppparse.c into regular 
> ones. The one at the top of smp_scan_config() in particular also 
> prints on !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines 
> without anything resembling MP tables which makes their lowly UP 
> owners wonder...
> 
> given that it was up to this point also not considered valuable 
> user-level information, let's just kill that one.

hm, i found it useful in the past in about 2-3 cases.

How about a patch that makes the printout depend on apic=debug ? That 
way the message can still be there in case of bugreports that somehow 
deal with SMP or APIC bugs (without having to recompile the kernel).

The way to make the printout depend on apic=debug/verbose is to do 
something like this:

	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n", bp, length);

Would you mind to send a patch for that?

Thanks,

	Ingo
