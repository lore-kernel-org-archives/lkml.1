Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXLEPkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXLEPkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXLEPkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:40:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbXLEPkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:40:39 -0500
Date: Wed, 5 Dec 2007 16:40:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071205154014.GA6491@elte.hu>
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756C3D9.9030107@jlab.org>
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


* Jie Chen <chen@jlab.org> wrote:

> I just ran the same test on two 2.6.24-rc4 kernels: one with 
> CONFIG_FAIR_GROUP_SCHED on and the other with CONFIG_FAIR_GROUP_SCHED 
> off. The odd behavior I described in my previous e-mails were still 
> there for both kernels. Let me know If I can be any more help. Thank 
> you.

ok, i had a look at your data, and i think this is the result of the 
scheduler balancing out to idle CPUs more agressively than before. Doing 
that is almost always a good idea though - but indeed it can result in 
"bad" numbers if all you do is to measure the ping-pong "performance" 
between two threads. (with no real work done by any of them).

the moment you saturate the system a bit more, the numbers should 
improve even with such a ping-pong test.

do you have testcode (or a modification of your testcase sourcecode) 
that simulates a real-life situation where 2.6.24-rc4 performs not as 
well as you'd like it to see? (or if qmt.tar.gz already contains that 
then please point me towards that portion of the test and how i should 
run it - thanks!)

	Ingo
