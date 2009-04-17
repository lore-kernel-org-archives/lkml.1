Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbZDQQtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbZDQQtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbZDQQtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:49:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60658 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbZDQQtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:49:46 -0400
Date: Fri, 17 Apr 2009 18:49:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
Message-ID: <20090417164918.GK8253@elte.hu>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com> <1239951613.23397.4107.camel@laptop> <alpine.DEB.1.10.0904170941020.11877@qirst.com> <1239977776.23397.4590.camel@laptop> <alpine.DEB.1.10.0904171021360.20239@qirst.com> <1239979901.23397.4638.camel@laptop> <alpine.DEB.1.10.0904171100510.21575@qirst.com> <20090417153520.GA29968@elte.hu> <alpine.DEB.1.10.0904171142050.13734@qirst.com> <1239985426.23397.4757.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239985426.23397.4757.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > > Is the overhead 1%? 2%? 0.5%? And how did it change from 
> > > 2.6.22 onwards? Did it go up by 0.1%, from 1% to 1.1%? Or did 
> > > the average go down by 0.05%, while increasing the spread of 
> > > events (thus fooling your cutoff)?
> > 
> > As you see in the diagrams provided there is a 4 fold increase 
> > in the number of interrupts >1usecs when going from 2.6.22 to 
> > 2.6.23. How would you measure the overhead? Time spent in the 
> > OS? Disturbance of the caches by the OS that cause the 
> > application to have to refetch data from Ram?
> 
> You could for example run an NMI profiler at 10000 Hz and collect 
> samples. Or use PMU hardware to collect numbers

it's even simpler than that: use a user-space loop and an alert() 
based signal-handler triggered measurement to count the number of 
loops user-space can execute, per second.

Such measurements can very easily be made much more precise than 
0.1%, and in a tight loop there's basically no caching issues - it 
measures pure 'cycles left for user-space' performance.

	Ingo
