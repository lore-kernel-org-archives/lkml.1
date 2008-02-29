Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbYB2Vci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbYB2Vci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbYB2Vc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:32:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229AbYB2Vc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:32:28 -0500
Date: Fri, 29 Feb 2008 22:32:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Jackson <pj@sgi.com>, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-ID: <20080229213207.GN27212@elte.hu>
References: <20080227222103.673194000@chello.nl> <1204311351.6243.130.camel@lappy> <20080229145516.4d96aeaa.pj@sgi.com> <1204319674.6243.145.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204319674.6243.145.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > Could you educate me a little, Peter, on what these irqs are and on 
> > the sorts of ways people might want to place them across CPUs?
> 
> I'm not sure I know what you're asking. IRQ are hardware notifiers and 
> do all kinds of things depending on the hardware. Network cards 
> typically use them to notify the CPU of incoming packets. Video cards 
> can do vsync notifiers, empty dma buffers, whatnot.

irq affinity masks can basically be thought of as: "these are the CPUs 
where external hardware events will trigger certain kernel functions and 
cause overhead on those CPUs". An IRQ can have followup effects: softirq 
execution, workqueue execution, etc.

so managing the IRQ masks is very meaningful and just as meaningful as 
managing the affinity masks of tasks. You can think of "IRQ# 123" as 
"special kernel task # 123".

	Ingo
