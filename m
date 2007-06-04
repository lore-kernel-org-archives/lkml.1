Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbXFDTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbXFDTBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbXFDTBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:01:08 -0400
Received: from www.osadl.org ([213.239.205.134]:46992 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759969AbXFDTBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:01:05 -0400
Subject: Re: iperf: performance regression (was b44 driver problem?)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Michael Buesch <mb@bu3sch.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070604105158.31ede1f5@freepuppy>
References: <20070525172431.60affaca@freepuppy>
	 <200705281944.05030.maxi@daemonizer.de> <1180380230.3657.3.camel@chaos>
	 <200706031826.06891.maxi@daemonizer.de> <1180939188.4404.5.camel@chaos>
	 <20070604090918.42386fbb@freepuppy> <1180974958.4404.24.camel@chaos>
	 <20070604095924.651d91c8@freepuppy> <1180978368.4404.29.camel@chaos>
	 <20070604105158.31ede1f5@freepuppy>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 21:00:47 +0200
Message-Id: <1180983647.4404.38.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 10:51 -0700, Stephen Hemminger wrote:
> > I doubt that. This is in the iperf code itself.
> > 
> > void thread_rest ( void ) {
> > #if defined( HAVE_THREAD )
> > #if defined( HAVE_POSIX_THREAD )
> >     // TODO add checks for sched_yield or pthread_yield and call that
> >     // if available
> >     usleep( 0 );
> > 
> > ----------^^^^
> > 
> > It results in a nanosleep({0,0}, NULL)
> > 
> > 	tglx
> > 
> 
> Yes, the following patch makes iperf work better than ever.
> But are other broken applications going to have same problem.
> Sounds like the old "who runs first" fork() problems.

Not really. The fork() "who runs first" problem is nowhere specified.

usleep(0) is well defined:

.... If the value of useconds is 0, then the call has no effect.

So the call into the kernel has been wrong for quite a time.

	tglx


