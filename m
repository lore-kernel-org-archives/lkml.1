Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbXEBLSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbXEBLSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXEBLSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:18:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbXEBLSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:18:30 -0400
Date: Wed, 2 May 2007 13:17:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502111742.GA18132@elte.hu>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46386F2B.9050307@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> The problem is with comparing a s64 values with (s64)ULONG_MAX, which 
> evaluates to -1. Then we check if exec_delta64 and fair_delta64 are 
> greater than (s64)ULONG_MAX (-1), if so we assign (s64)ULONG_MAX to 
> the respective values.

ah, indeed ...

> The fix is to compare these values against (s64)LONG_MAX and assign 
> (s64)LONG_MAX to exec_delta64 and fair_delta64 if they are greater 
> than (s64)LONG_MAX.
> 
> Tested on PowerPC, the regression is gone, tasks are load balanced as 
> they were in v7.

thanks, applied!

	Ingo
