Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbYB2TC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbYB2TC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYB2TCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:02:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748AbYB2TCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:02:48 -0500
Date: Fri, 29 Feb 2008 20:02:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       Max Krasnyanskiy <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-ID: <20080229190223.GA17820@elte.hu>
References: <20080227222103.673194000@chello.nl> <1204311351.6243.130.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204311351.6243.130.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> @@ -174,11 +174,20 @@ struct irq_desc {
>  #ifdef CONFIG_PROC_FS
>  	struct proc_dir_entry	*dir;
>  #endif
> +#ifdef CONFIG_CPUSETS
> +	struct cpuset		*cs;
> +#endif

i like this approach - it makes irqs more resource-alike and attaches 
them to a specific resource control group.

So if /cgroup/boot is changed to have less CPUs then the "default" irqs 
move along with it.

but if an isolated RT domain has specific irqs attached to it (say the 
IRQ of some high-speed data capture device), then the irqs would move 
together with that domain.

irqs are no longer a bolted-upon concept, but more explicitly managed.

[ If you boot-test it and if Paul agrees with the general approach then
  i could even apply it to sched-devel.git ;-) ]

	Ingo
