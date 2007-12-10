Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXLJJMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXLJJMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXLJJL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:11:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXLJJL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:11:56 -0500
Date: Mon, 10 Dec 2007 10:10:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ego@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071210091052.GA14487@elte.hu>
References: <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com> <20071209074647.GE22981@elte.hu> <20071210081952.GA7215@in.ibm.com> <475CFF01.2090502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475CFF01.2090502@gmail.com>
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


> > softlockup: remove get_online_cpus() which doesn't help here.
> > 
> > The get_online_cpus() protection seems to be bogus in 
> > kernel/softlockup.c as cpu cached in check_cpu can go offline once 
> > we do a put_online_cpus().
> > 
> > This can also cause deadlock during a cpu offline as follows:

i'm wondering, what's the proper CPU-hotplug safe sequence here then? 
I'm picking a CPU number from cpu_online_map, and that CPU could go away 
while i'm still using it, right? What's saving us here?

	Ingo
