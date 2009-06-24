Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZFXMp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZFXMp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZFXMpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:45:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFXMpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:45:49 -0400
Date: Wed, 24 Jun 2009 14:45:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624124542.GB32306@elte.hu>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624142828.7c6a2337@skybase> <20090624123416.GB9510@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624123416.GB9510@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> My current plan is to migrate things over to the perf_counter API 
> and annoy Ingo with my interrupt deprived counters ;-)

Please do :-)

I just wrote a longer explanation about them: i think they can be 
made full-blown hardware counters, which in the end would be 
basically just as capable as 'real' IRQ capable counters.

The main complication that such counters bring is that in their 'own 
metric' they do interrupt periods in an 'irregular' way (because 
they interrupt in the nanosec metric - being hrtimers) - but both 
the tools can deal with uneven periods just fine and the auto-freq 
code can auto-balance based on this just fine too.

So you should be able to implement this within arch/sh/ with 
existing perf_counter facilities and hrtimers, or you can help us 
librarize it in kernel/perf_counter.c some more, to minimize 
architecture code.

[ Of course, given that you are the first architecture to do this,
  you would be fair to expect some unexpected details along the way 
  as well ;-) ]

	Ingo
