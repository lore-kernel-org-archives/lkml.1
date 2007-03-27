Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbXC0TQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbXC0TQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934193AbXC0TQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:16:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192AbXC0TQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:16:34 -0400
Date: Tue, 27 Mar 2007 21:15:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH -rt] fix setting of preempt_max_latency and preempt_thresh on 64 bit systems
Message-ID: <20070327191548.GC29929@elte.hu>
References: <1175015947.19634.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175015947.19634.6.camel@localhost.localdomain>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I wasn't able to turn on latency tracing on a x86_64 box. Using logdev 
> to see what was happening, I found that echoing 0 into 
> /proc/sys/kernel/preempt_max_latency would only change the max from 
> -1ULL to 0xffffffff00000000. Which would keep the max pretty high 
> still.

ah! This should explain Roland Dreier's report about tracing not working 
on x86_64.

> The problem is in sysctl.c where preempt_max_latency can be modified. 
> On systems where cycle_t is greater than the size of int (x86_64) we 
> only write to the 4 LSB.
> 
> Here's the patch:

thanks, applied.

	Ingo
