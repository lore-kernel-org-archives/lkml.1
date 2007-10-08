Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXJHRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXJHRAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXJHRAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:00:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36589 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbXJHRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:00:43 -0400
Date: Mon, 8 Oct 2007 19:00:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Frans Pop <elendil@planet.nl>, Chuck Ebbert <cebbert@redhat.com>,
       Luca Tettamanti <kronos.it@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: [PATCH for testing] Re: Decreasing stime running confuses top
Message-ID: <20071008170023.GA31765@elte.hu>
References: <200710031433.34504.elendil@planet.nl> <200710042310.25223.borntraeger@de.ibm.com> <200710051749.33381.elendil@planet.nl> <200710081849.04380.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710081849.04380.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1133]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Why does it still shows numbers going backwards? I guess the sampled 
> values for stime and utime change in flight between task_utime and 
> task_stime are called. Lets say utime will be increased. Given the 
> same sum_exec_runtime that means that the result of task_stime() will 
> get smaller at this point.
> 
> So Chucks patch only deals with sum_exec_runtime changing.

basically sum_exec_runtime is split up to form a precise utime/stime, 
using the stime/utime ratio as the factor.

> > It seems to me that this patch would be the best option for 2.6.23.
> 
> Ingo, do you have any opinion about how to proceed?

the problem occurs when there's a different "split" dictated by 
p->stime/p->utime. The sum of stime+utime as reported should be 
monotonic, but the individual components may not. (the reason is that we 
have a precise "sum" for free, given by the scheduler, but we do not 
want the overhead of per-syscall timestamps to get a precise stime/utime 
numbers. So we sample p->stime and p->utime from the scheduler tick.)

	Ingo
