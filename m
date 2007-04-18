Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXDRIzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXDRIzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030763AbXDRIzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:55:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:58067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030524AbXDRIzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:55:43 -0400
Date: Wed, 18 Apr 2007 10:55:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418085525.GA21194@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <46247DAB.1060808@shadowen.org> <20070417093257.GA9267@wotan.suse.de> <20070417095900.GB25553@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417095900.GB25553@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 11:59:00AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > 2.6.21-rc7-cfs-v2
> > 534.80user 30.92system 2:23.64elapsed 393%CPU
> > 534.75user 31.01system 2:23.70elapsed 393%CPU
> > 534.66user 31.07system 2:23.76elapsed 393%CPU
> > 534.56user 30.91system 2:23.76elapsed 393%CPU
> > 534.66user 31.07system 2:23.67elapsed 393%CPU
> > 535.43user 30.62system 2:23.72elapsed 393%CPU
> 
> Thanks for testing this! Could you please try this also with:
> 
>    echo 100000000 > /proc/sys/kernel/sched_granularity

507.68user 31.87system 2:18.05elapsed 390%CPU
507.99user 31.93system 2:18.09elapsed 390%CPU
507.46user 31.78system 2:18.03elapsed 390%CPU
507.68user 31.93system 2:18.11elapsed 390%CPU
507.63user 31.98system 2:18.01elapsed 390%CPU
507.83user 31.94system 2:18.28elapsed 390%CPU

> could you maybe even try a more extreme setting of:
> 
>    echo 500000000 > /proc/sys/kernel/sched_granularity

504.87user 32.13system 2:18.03elapsed 389%CPU
505.94user 32.29system 2:17.87elapsed 390%CPU
506.10user 31.90system 2:17.96elapsed 389%CPU
505.02user 32.02system 2:17.96elapsed 389%CPU
506.69user 31.96system 2:17.82elapsed 390%CPU
505.70user 31.84system 2:17.90elapsed 389%CPU


Again, for comparison 2.6.21-rc7 mainline:

508.87user 32.47system 2:17.82elapsed 392%CPU
509.05user 32.25system 2:17.84elapsed 392%CPU
508.75user 32.26system 2:17.83elapsed 392%CPU
508.63user 32.17system 2:17.88elapsed 392%CPU
509.01user 32.26system 2:17.90elapsed 392%CPU
509.08user 32.20system 2:17.95elapsed 392%CPU

So looking at elapsed time, a granularity of 100ms is just behind the
mainline score. However it is using slightly less user time and
slightly more idle time, which indicates that balancing might have got
a bit less aggressive.

But anyway, it conclusively shows the efficiency impact of such tiny
timeslices.
