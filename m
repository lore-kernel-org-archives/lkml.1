Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbYHVEoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbYHVEoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 00:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYHVEoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 00:44:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51986 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbYHVEoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 00:44:00 -0400
Date: Fri, 22 Aug 2008 06:37:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080822043715.GD15212@elte.hu>
References: <20080821234318.GA1754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821234318.GA1754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> +#define MAX_RCU_LEVELS 3
> +#if NR_CPUS <= CONFIG_RCU_FANOUT
> +#define NUM_RCU_LEVELS 1
> +#define NUM_RCU_LEVEL_1 1
> +#define NUM_RCU_LEVEL_2 NR_CPUS
> +#define NUM_RCU_LEVEL_3 0
> +#define NUM_RCU_LEVEL_4 0
> +#define NUM_RCU_NODES NUM_RCU_LEVEL_1
> +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> +#define NUM_RCU_LEVELS 2
> +#define NUM_RCU_LEVEL_1 1
> +#define NUM_RCU_LEVEL_2 \
> +	(((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT))
> +#define NUM_RCU_LEVEL_3 NR_CPUS
> +#define NUM_RCU_LEVEL_4 0
> +#define NUM_RCU_NODES \
> +	((NUM_RCU_LEVEL_1) + (NUM_RCU_LEVEL_2))
> +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> +#define NUM_RCU_LEVELS 3
> +#define RCU_FANOUT_SQ ((CONFIG_RCU_FANOUT) * (CONFIG_RCU_FANOUT))
> +#define NUM_RCU_LEVEL_1 1
> +#define NUM_RCU_LEVEL_2 \
> +	(((NR_CPUS) + (RCU_FANOUT_SQ) - 1) / (RCU_FANOUT_SQ))
> +#define NUM_RCU_LEVEL_3 \
> +	((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT)
> +#define NUM_RCU_LEVEL_4 NR_CPUS
> +#define NUM_RCU_NODES \
> +	((NUM_RCU_LEVEL_1) + \
> +	 (NUM_RCU_LEVEL_2) + \
> +	 (NUM_RCU_LEVEL_3))
> +#else
> +#error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> +#endif

just a quick stylistic suggestion: if feasible then such sizing ugliness 
should be hidden in a Kconfig file. (if Kconfig is capable enough for 
this that is)

	Ingo
