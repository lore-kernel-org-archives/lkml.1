Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbZBXTgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbZBXTgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZBXTgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:36:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbZBXTgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:36:37 -0500
Date: Tue, 24 Feb 2009 20:36:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, srostedt@redhat.com
Subject: Re: [patch 1/6] x86, ftrace, hw-branch-tracer: support hotplug cpus
Message-ID: <20090224193622.GA26734@elte.hu>
References: <20090119102653.A18774@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119102653.A18774@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Support hotplug cpus.

> +static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
> +				     unsigned long action, void *hcpu)
> +{
> +	unsigned int cpu = (unsigned long)hcpu;
> +
> +	mutex_lock(&bts_tracer_mutex);

This is buggy: CPU hotplug handlers must not sleep (they are 
called with irqs disabled), while this code does a mutex_lock() 
which can sleep.

	Ingo
