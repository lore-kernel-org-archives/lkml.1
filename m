Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbXDGJrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbXDGJrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXDGJrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:47:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbXDGJrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:47:16 -0400
Date: Sat, 7 Apr 2007 11:47:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [patch] high-res timers: UP resume fix
Message-ID: <20070407094705.GA20998@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070407082554.GA1943@elte.hu> <1175935730.28263.510.camel@localhost.localdomain> <200704071148.43136.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071148.43136.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > We do in on_each_cpu() unconditionally. I missed that.
> 
> BTW, the on_each_cpu() in clock_was_set() is unnecessary, because 
> timekeeping_resume() is always run on one CPU.

yes - but that's not the only place where we do clock_was_set(), and the 
on_each_cpu() is necessary in every other case. So i think the right 
solution was the patch i did: to split the resume functionality from the 
clock_was_set() functionality.

	Ingo
