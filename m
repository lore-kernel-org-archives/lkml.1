Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZAZWSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZAZWSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZAZWSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:18:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbZAZWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:18:21 -0500
Date: Mon, 26 Jan 2009 23:17:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       rusty@rustcorp.com.au, travis@sgi.com, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126221729.GA10215@elte.hu>
References: <20090124001537.7cfde78e.akpm@linux-foundation.org> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org> <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126215049.GA3493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126215049.GA3493@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> But "[PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in 
> work_on_cpu." removes get_online_cpus/put_online_cpus, this means the 
> work can run on the wrong CPU anyway. Or work_on_cpu() can hang forever 
> if CPU has already gone away before queue_work_on().
> 
> Confused.

The idea was to require work_on_cpu() users to be CPU hotplug-safe. But 
... Rusty pointed it out in the past that this might be fragile, and we 
could put back the get_online_cpus()/put_online_cpus() calls.

Rusty, what do you think?

	Ingo
