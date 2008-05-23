Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYEWKLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYEWKLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYEWKLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:11:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYEWKLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:11:35 -0400
Date: Fri, 23 May 2008 12:10:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Greg Smith <gsmith@gregsmith.com>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
Message-ID: <20080523101000.GA13964@elte.hu>
References: <1211440207.5733.8.camel@marge.simson.net> <20080522082814.GA4499@linux.vnet.ibm.com> <1211447105.4823.7.camel@marge.simson.net> <1211452465.7606.8.camel@marge.simson.net> <1211455553.4381.9.camel@marge.simson.net> <1211456659.29104.20.camel@twins> <1211458176.5693.6.camel@marge.simson.net> <1211459081.29104.40.camel@twins> <Pine.GSO.4.64.0805230232190.28654@westnet.com> <1211536814.5851.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211536814.5851.18.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> My take on the numbers is that both kernels preempt too frequently for 
> _this_ load.. but what to do, many many loads desperately need 
> preemption to perform.
> 
>       2.6.22.18     2.6.22.18-batch          2.6.26.git    2.6.26.git.batch
> 1   7487.115236         7643.563512         9999.400036         9915.823582
> 2  17074.869889        15360.150210        14042.644140        14958.375329
> 3  25073.139078        24802.446538        15621.206938        25047.032536
> 4  24236.413612        26126.482482        16436.055117        25007.183313
> 5  26367.198572        28298.293443        19926.550734        27853.081679
> 6  24695.827843        30786.651975        22375.916107        28119.474302
> 8  21020.949689        31973.674156        25825.292413        31070.664011
> 10 22792.204610        31775.164023        26754.471274        31596.415197
> 15 21202.173186        30388.559630        28711.761083        30963.050265
> 20 21204.041830        29317.044783        28512.269685        30127.614550
> 30 18519.965964        27252.739106        26682.613791        28185.244056
> 40 17936.447579        25670.803773        24964.936746        26282.369366
> 50 16247.605712        25089.154310        21078.604858        25356.750461

was 2.6.26.git.batch running the load with SCHED_BATCH, or did you do 
other tweaks as well?

if it's other tweaks as well then could you perhaps try to make 
SCHED_BATCH batch more agressively?

I.e. i think it's a perfectly fine answer to say "if your workload needs 
batch scheduling, run it under SCHED_BATCH".

	Ingo
