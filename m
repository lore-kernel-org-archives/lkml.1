Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbXGFFRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbXGFFRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbXGFFRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:17:41 -0400
Received: from www.osadl.org ([213.239.205.134]:46029 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753010AbXGFFRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:17:40 -0400
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
From: Thomas Gleixner <tglx@linutronix.de>
To: Ernie Petrides <petrides@redhat.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200707052312.l65NCjfb025915@pasta.boston.redhat.com>
References: <200707052312.l65NCjfb025915@pasta.boston.redhat.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 07:17:26 +0200
Message-Id: <1183699046.3289.51.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 19:12 -0400, Ernie Petrides wrote:
> On Thursday, 5-Jul-2007 at 16:49 MDT, Chris Friesen wrote:
> 
> > Ernie Petrides wrote:
> > 
> > > Only kernels built with the CONFIG_HIGH_RES_TIMERS option enabled were
> > > vulnerable.
> > 
> > As I mentioned in my post to Thomas, we have high res timers disabled 
> > and were still affected.  Granted, our kernel has been modified so it is 
> > possible that vanilla would not be affected....I haven't tested it.
> > 
> > Chris
> 
> That's odd, because Thomas's patch removed two calls to clock_was_set(),
> which is a no-op when CONFIG_HIGH_RES_TIMERS is not enabled (at least in
> the 2.6.21 source tree).
> 
> Also, I personally tested with the reproducer you posted here, initially
> on a box running 2.6.22-rc4, and there were no problems (but I'm not sure
> what config options were enabled on that kernel).  I did reproduce the
> problem on a stock 2.6.21 kernel with CONFIG_HIGH_RES_TIMERS enabled.

It needs a running smp_call_function() to be interrupted by the timer
interrupt, which calls clock_was_set(). So it's not that easy to
reproduce.

	tglx


