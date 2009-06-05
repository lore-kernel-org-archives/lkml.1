Return-Path: <linux-kernel-owner+w=401wt.eu-S1751343AbZFELy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbZFELy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFELyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:54:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZFELyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:54:15 -0400
Date: Fri, 5 Jun 2009 13:54:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
	policy flag, Second try
Message-ID: <20090605115410.GA16008@elte.hu>
References: <20090529083840.GA15516@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529083840.GA15516@omega>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0208]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lennart Poettering <mzxreary@0pointer.de> wrote:

> Why expose this via sched_setscheduler() and not other syscalls 
> such as prctl() or sched_setparam()?
> 
> prctl() does not take a pid parameter. Due to that it would be 
> impossible to modify this flag for other processes than the 
> current one.
> 
> The struct passed to sched_setparam() can unfortunately not be 
> extended without breaking compatibility, since sched_setparam() 
> lacks a size parameter.

Well, it could be extended, if we wanted to. Right now 
sched_priority has a valid value of 0 to 100. We could introduce a 
new value '-1' to mean: 'extended struct sched_param'.

A new getparam syscall could then be introduced - only used by new 
user-space.

	Ingo
