Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYGCNnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYGCNnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYGCNne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:43:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbYGCNnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:43:32 -0400
Date: Thu, 3 Jul 2008 15:43:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: next-0703: build failure in x86/entry_64.S
Message-ID: <20080703134300.GA499@elte.hu>
References: <a4423d670807030600y3b1e651end20b9993ca5c8d94@mail.gmail.com> <20080703133132.GC12102@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703133132.GC12102@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, cannot reproduce it here with linux-next-0702.
> 
> but ... this looks quite similar to an issue triggered by the 
> tip/x86/xen-64bit topic (and fixed by the patch below) - but that's 
> not in linux-next yet.

ok, i can see the same problem in linux-next-0703 and git-cherry-picking 
the commit below fixes it. I have also pushed out a new version of 
auto-generic-ipi-next which caused this problem.

> commit 6d2a6e57be1582b017a39f52385adf49d7cc4b0f
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Fri Jun 27 12:04:03 2008 -0700
> 
>     x86_64: fix non-paravirt compilation
>     
>     Make sure SWAPGS and PARAVIRT_ADJUST_EXCEPTION_FRAME are properly
>     defined when CONFIG_PARAVIRT is off.
>     
>     Fixes Ingo's build failure:
>     arch/x86/kernel/entry_64.S: Assembler messages:
>     arch/x86/kernel/entry_64.S:1201: Error: invalid character '_' in mnemonic
>     arch/x86/kernel/entry_64.S:1205: Error: invalid character '_' in mnemonic
>     arch/x86/kernel/entry_64.S:1209: Error: invalid character '_' in mnemonic
>     arch/x86/kernel/entry_64.S:1213: Error: invalid character '_' in mnemonic

	Ingo
