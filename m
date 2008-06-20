Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYFTNrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYFTNrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYFTNrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:47:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYFTNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:47:42 -0400
Date: Fri, 20 Jun 2008 15:46:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
Message-ID: <20080620134637.GA8135@elte.hu>
References: <1213739834.3803.137.camel@johannes.berg> <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org> <1213774177.3803.164.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213774177.3803.164.camel@johannes.berg>
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> Subject: clean up and comment local_bh_enable code
> 
> There's no need to use local_irq_save() over local_irq_disable() in 
> the local_bh_enable code since it is a bug to call it with irqs 
> disabled and do_softirq will enable irqs if there is any pending work. 
> Consolidate the code from local_bh_enable and ..._ip to avoid having a 
> disconnect between them in the warnings they trigger that is currently 
> there. Also always trigger the warning on in_irq(), not just in the 
> trace-irqflags case.

applied to tip/core/softirq for testing, thanks Johannes.

	Ingo
