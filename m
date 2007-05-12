Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbXELBB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbXELBB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXELBBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:01:19 -0400
Received: from mail.screens.ru ([213.234.233.54]:52925 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXELBBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:01:18 -0400
Date: Sat, 12 May 2007 05:01:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512010117.GB540@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl> <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl> <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org> <20070511232024.GA489@tv-sign.ru> <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org> <20070511234819.GA508@tv-sign.ru> <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org> <20070512004057.GA540@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512004057.GA540@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Oleg Nesterov wrote:
> 
> Do we need freezer? Should we freeze kernel threads? I can't judge. I tried
> to read a long thread about suspend, and failed to understand it.
> 
> I personally think we can simplify things if CPU-hotplug use freezer, at least.

Just a small example,

	debug_smp_processor_id:

		/*
		 * Kernel threads bound to a single CPU can safely use
		 * smp_processor_id():
		 */
		this_mask = cpumask_of_cpu(this_cpu);

		if (cpus_equal(current->cpus_allowed, this_mask))
			goto out;

This is not true with CONFIG_HOTPLUG_CPU. This becomes true if we freeze
the kernel threads from CPU_DOWN_PREPARE to CPU_DEAD.

Oleg.

