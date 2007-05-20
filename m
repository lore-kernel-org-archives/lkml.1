Return-Path: <linux-kernel-owner+w=401wt.eu-S1764757AbXETDEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764757AbXETDEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 23:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbXETDEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 23:04:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:44355 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734AbXETDEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 23:04:07 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1179628991.20925.2.camel@imap.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	 <1179500217.20519.53.camel@imap.mvista.com>
	 <464DC0DC.7050809@ru.mvista.com>
	 <1179502773.20519.56.camel@imap.mvista.com>
	 <17998.28659.702653.237011@cargo.ozlabs.ibm.com>
	 <1179628991.20925.2.camel@imap.mvista.com>
Content-Type: text/plain
Date: Sun, 20 May 2007 13:03:10 +1000
Message-Id: <1179630190.32247.534.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 19:43 -0700, Daniel Walker wrote:

> In terms of clocksources, gettimeofday() would have to switch to another
> clocksource if the decrementer started to act that way .. That's why it
> is possible to register more than one clocksource, to allow for the
> switching. The decrementer frequency doesn't change even with cpufreq? 

It's more than just gettimeofday. The linux ppc kernel port has strong
assumptions all over the place that the timbase and decrementer (which
always tick at the same rate) have a constant frequency. It might be
possible to "fix" those assumptions but right now, that is the case.

For example, nowadays, udelay() also uses the timebase. Not only
gettimeofday() & friends. The scheduler ticking too. The precise process
accounting as well, etc...

In fact, while it's never worded explicitely in the spec, it's always
been strongly in the "spirit" of the architecture that the timebase and
decrementer have a constant frequency. This is why processors like the
970 allow for an external sourcing for when they are used in setups
where the various clocks are slewed for power management.

Ben.


