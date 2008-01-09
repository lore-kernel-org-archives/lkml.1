Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYAINVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYAINVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYAINVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:21:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53386 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbYAINVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:21:05 -0500
Date: Wed, 9 Jan 2008 14:20:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, Arjan van de Ven <arjan@infradead.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Analysis of sched_mc_power_savings
Message-ID: <20080109132014.GF27196@elte.hu>
References: <20080108173815.GA7793@dirshya.in.ibm.com> <20080108212400.GA8903@linux-os.sc.intel.com> <20080109111302.GC7793@dirshya.in.ibm.com> <20080109113507.GA29721@elte.hu> <20080109122847.GA28955@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109122847.GA28955@dirshya.in.ibm.com>
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> I will watch this during the experiments.  I have been using klog 
> application to dump relayfs data.  I did run powertop and top as well, 
> I will bind them to certain CPUs and isolate their impact.
> 
> I believe the margin of error would be less since all the measurement 
> tasks sleep for long duration.

ok, long duration ought to be enough.

i think a possible explanation of your observtions would be this: sleepy 
workloads are affected more by the wakeup logic, and most of the 
power-savings works via runtime balancing.

So perhaps try to add some SD_POWERSAVINGS_BALANCE logic to 
try_to_wake_up()? I think waking up on the same CPU where it went to 
sleep is the most power-efficient approach in general. (or always waking 
up where the wakee runs - this should be measured.) Right now 
try_to_wake_up() tries to spread out load opportunistically, which is 
throughput-maximizing but it's arguably not very power conscious.

	Ingo
