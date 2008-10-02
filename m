Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYJBINW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYJBINW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYJBING
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:13:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbYJBINC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:13:02 -0400
Date: Thu, 2 Oct 2008 10:07:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, laijs@cn.fujitsu.com,
       manfred@colorfullife.com, dipankar@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, josht@linux.vnet.ibm.com
Subject: Re: [PATCH,RFC] RCU-based detection of stalled CPUs for Classic RCU
Message-ID: <20081002080726.GB17695@elte.hu>
References: <20081002003628.GA7877@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002003628.GA7877@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> This patch adds stalled-CPU detection to Classic RCU.  This capability 
> is enabled by a new config variable CONFIG_RCU_CPU_STALL_DETECTOR, 
> which defaults disabled.  This is a debugging feature, not something 
> that non-kernel-hackers would be expected to care about.  This feature 
> can detect looping CPUs in !PREEMPT builds and looping CPUs with 
> preemption disabled in PREEMPT builds.  This is essentially a port of 
> this functionality from the treercu patch.
> 
> One current shortcoming: on some systems, stalls are detected during 
> early boot, when we normally would not care about them.  My thought is 
> to add a call from late initialization to suppress stall detection 
> until the system is well along its way to being booted, but thought I 
> should check to see if there might already be something for this 
> purpose.

could you be a bit more specific, why do those warnings show up and why 
dont we care about them? There are things like networking that 
occasionally do an rcu_sync() and a stall could mean a bootup hang.

> (Currently against 2.6.27-rc8, FYI.)
> 
> Thoughts?
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

i think this is a very good idea in general - often the question comes 
up whether a hang seen in the RCU code is indeed caused by RCU or other 
factors. Could you perhaps rebase it against tip/core/rcu ? [or 
tip/master for convenience]

	Ingo
