Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZALVrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZALVrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZALVq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:46:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZALVq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:46:56 -0500
Date: Mon, 12 Jan 2009 22:46:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: andi@firstfloor.org, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090112214643.GD7320@elte.hu>
References: <20090112213539.GA10720@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112213539.GA10720@gambetta>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederik Deweerdt <frederik.deweerdt@xprog.eu> wrote:

> Hi,
> 
> On x86_64 flush tlb data is stored in per_cpu variables. This is 
> unnecessary because only the first NUM_INVALIDATE_TLB_VECTORS entries 
> are accessed.
>
> This patch aims at making the code less confusing (there's nothing 
> really "per_cpu") by using a plain array. It also would save some memory 
> on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).

indeed, well spotted!

This construct was indeed an abuse of the per_cpu facilities.

Note that beyond the obvious memory savings, your patch should make the 
code a bit faster and a bit smaller as well in the SMP TLB flush codepath: 
the smp_flush_state data structure is 64 (or 128) bytes so static array 
arithmetics will be faster than the per_cpu indirection.

I have applied your patch to tip/x86/mm, thanks Frederik!

	Ingo
