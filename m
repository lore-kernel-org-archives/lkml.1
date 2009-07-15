Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZGOVxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZGOVxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZGOVxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:53:08 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5664 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754997AbZGOVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:53:07 -0400
Date: Wed, 15 Jul 2009 17:53:05 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Henrik Austad <henrik@austad.us>
Cc: "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090715215305.GD14993@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <1247589099.7500.191.camel@twins> <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu> <200907142128.48558.henrik@austad.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907142128.48558.henrik@austad.us>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 09:28:47PM +0200, Henrik Austad wrote:

> ... In MC you need to do this the hard way, namely compute the
> point in time not when the task misses the deadline, but when it
> will *eventually* fail a deadline. By doing that, you combine
> deadline, wcet and granted time in one variable, and you have a
> *single* variable to compare.

This is true in a theoretical sense, and is the basis of some
"optimal" scheduling algorithms, including the "throwforward
scheduling" algorithm.  It makes sense in some environments, where
you actually know the WCET of the task in advance.  However, I
don't believe a Linux system can expect all applications to
provide this kind of information.

In a system programmed using process and threads, the decision to
sleep or wake is embedded in the internal logic of the thread, and
implemented by system calls.  The existing system calls do not
convey how long the thread needs to execute before it reaches its
next suspension point.  Therefore, without a new API you cannot
use WCET. If you create a new API for this, you are limiting this
form of scheduling to threads that choose to use that API, and are
able to provide the needed WCET information.  This seems like a
small number of cases among the full range of real-time Linux
applications.

Ted
