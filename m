Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXLBPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXLBPsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXLBPsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:48:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXLBPsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:48:11 -0500
Date: Sun, 2 Dec 2007 16:47:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202154746.GA27069@elte.hu>
References: <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202135711.GA20434@elte.hu> <20071202141117.GB9516@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071202141117.GB9516@lazybastard.org>
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


* Jörn Engel <joern@logfs.org> wrote:

> I do.  Went through 10odd runs and annotated the function right below 
> mcount each time.  Seems to work now.
> 
> Trouble is that it doesn't solve my real problem at hand.  Something 
> is causing significant delays when writing to logfs.  Core logfs code 
> is not running, but may cause whatever other code is running and 
> burning up all the cpu time.  Wasting 100ms of "qemu-time" to write a 
> single page happens fairly frequently.
> 
> With the latency tracer the problem appears to have become worse.  Now 
> the loftlockup code triggers quite frequently.  Which makes a bit of 
> sense, as the problem is a busy CPU, rather than an idle one.

well what does the trace say, where do the delays come from? To get a 
quick overview you can make tracing lighter weight by doing:

 echo 0 > /proc/sys/kernel/mcount_enabled
 echo 1 > /proc/sys/kernel/trace_syscalls

(this turns the latency tracer into a "global strace" kind of tracer)

	Ingo
