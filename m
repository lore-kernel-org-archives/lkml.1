Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477Ab0AaAK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0AaAK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006Ab0AaAKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:10:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:36311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0AaAKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:10:25 -0500
Date: Sat, 30 Jan 2010 16:11:14 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100130161114.07278221@infradead.org>
In-Reply-To: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 17:45:51 -0600
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:

> Hello,
> 
> Currently we have a workload that depends on around 50 processes that
> wake up 1000 times a second do a small amount of work and go back to
> sleep.  This works great on RHEL 5 (2.6.18-164.6.1.el5), but on recent
> kernels we are unable to achieve 1000 iterations per second.  Using
> the simple test application below on RHEL 5 2.6.18-164.6.1.el5 I can
> run 500 of these processes on and still achieve 999.99 iterations per
> second.  Running just 10 of these processes on the same machine with
> 2.6.32.6 produces results like:
> ]

there's an issue with your expectation btw.
what your application does, in practice is

<wait 1 millisecond>
<do a bunch of work>
<wait 1 millisecond>
<do a bunch of work>
etc

you would only be able to get close to 1000 per second if "bunch of
work" is nothing.....but it isn't.
so lets assume "bunch of work" is 100 microseconds.. the basic period
of your program (ignoring any costs/overhead in the implementation) 
is 1.1 milliseconds, which is approximately 909 per second, not 1000!

I suspect that the 1000 you get on RHEL5 is a bug in the RHEL5 kernel
where it gives you a shorter delay than what you asked for; since it's
clearly not a correct number to get.

(and yes, older kernels had such rounding bugs, current kernels go
through great length to give applications *exactly* the delay they are
asking for....)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
