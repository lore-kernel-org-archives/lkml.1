Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYGROKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYGROKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYGROJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:09:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbYGROJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:09:56 -0400
Date: Fri, 18 Jul 2008 16:09:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for
	callbacks-processing(v2)
Message-ID: <20080718140930.GT6875@elte.hu>
References: <48708F2F.2060406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48708F2F.2060406@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> This is v2, it's a little deference from v1 that I
> had send to lkml.
> use ACCESS_ONCE
> use rcu_batch_after/rcu_batch_before for batch # comparison.
> 
> rcutorture test result:
> (hotplugs: do cpu-online/offline once per second)
> 
> No CONFIG_NO_HZ:           OK, 12hours
> No CONFIG_NO_HZ, hotplugs: OK, 12hours
> CONFIG_NO_HZ=y:            OK, 24hours
> CONFIG_NO_HZ=y, hotplugs:  Failed.
> (Failed also without my patch applied, exactly the same bug occurred,
> http://lkml.org/lkml/2008/7/3/24)

thanks, i've applied this to tip/core/rcu - but it would be nice have an 
ack/nak from Paul as well, before we can proceed further.

	Ingo
