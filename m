Return-Path: <linux-kernel-owner+w=401wt.eu-S1764691AbZAULzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764691AbZAULzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbZAULzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:55:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575AbZAULzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:55:06 -0500
Date: Wed, 21 Jan 2009 12:54:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep and debug objects together are broken?
Message-ID: <20090121115451.GA20696@elte.hu>
References: <20090120085559.GB19505@wotan.suse.de> <19f34abd0901201311t2425056dia6182812f7270297@mail.gmail.com> <20090121071950.GM24891@wotan.suse.de> <20090121114229.GA10606@elte.hu> <1232538602.4847.158.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232538602.4847.158.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-01-21 at 12:42 +0100, Ingo Molnar wrote:
> 
> > So by the time you'd rearm, there's a lot of tasks with no proper 
> > locking state built up. We might be able to re-arm via 
> > stop_machine_run perhaps.
> 
> Won't work either, kstopmachine only preempts everybody. We'd require 
> something stronger.

indeed - mutexes wont be covered.

> What we need is a point where there's guaranteed no locks held, for 
> regular tasks that would be a trip to userspace and back, but for kernel 
> tasks that's a bit harder -- does the freezer stuff guarantee this?

yes, that might be doable.

Sounds very fragile though.

	Ingo
