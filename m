Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbYFDVyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbYFDVyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYFDVyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:54:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45123 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYFDVyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:54:08 -0400
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
	have realtime uses)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: trimarchimichael@yahoo.it
Cc: Max Krasnyansky <maxk@qualcomm.com>, Mark Hounschell <dmarkh@cfl.rr.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Oeser <ioe-lkml@rameria.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <725760.23277.qm@web26207.mail.ukl.yahoo.com>
References: <725760.23277.qm@web26207.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 23:52:27 +0200
Message-Id: <1212616348.19205.29.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 21:44 +0000, Michael Trimarchi wrote:
> [ sorry if this is going OT ]
>  
> Hi,
>  
> >  
> > Furthermore, cpusets allow for isolated but load-balanced RT domains. We
> > now have a reasonably strong RT balancer, and I'm looking at implementing
> > a full partitioned EDF scheduler somewhere in the future.
> >  
>  
> I'm working on a partitioned EDF scheduler right now, and I have to
> face several issues, starting from the interface to use to expose the
> EDF scheduler to userspace, and the integration with the existing
> sched_rt policy.

I would add a sched_class above sched_rt and let sched_rt run in all
unclaimed time by sched_edf.

Have you looked at deadline inheritance to replace PI? I think it can be
done reasonably simple by replacing the plist with a RB tree.

> By now I'm experimenting with an additional sched_class that implements
> a SCHED_EDF policy, extending the POSIX struct sched_param with the
> EDF parameters of the task, do you see any better way to do that? 
> Could that approach be reasonable?

Yes, that is the way I'm leaning.

