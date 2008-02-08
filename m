Return-Path: <linux-kernel-owner+w=401wt.eu-S934057AbYBHK3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbYBHK3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbYBHK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:28:54 -0500
Received: from ns.suse.de ([195.135.220.2]:58030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225AbYBHK2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:28:53 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Simplify cpu_idle_wait
Date: Fri, 8 Feb 2008 11:28:48 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>, Adam Belay <abelay@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <1199759244.26343.35.camel@localhost.localdomain> <B5B0CFF685D7DF46A05CF1678CFB42ED20E00653@orsmsx423.amr.corp.intel.com> <20080208010550.GA8090@linux-os.sc.intel.com>
In-Reply-To: <20080208010550.GA8090@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081128.48621.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -	set_cpus_allowed(current, tmp);
> +	smp_mb();
> +	/* kick all the CPUs so that they exit out of pm_idle */
> +	smp_call_function(do_nothing, NULL, 0, 0);

I think the last argument (wait) needs to be 1 to make sure it is 
synchronous (for 32/64) Otherwise the patch looks great.

-Andi

