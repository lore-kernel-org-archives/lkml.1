Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZFBUdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZFBUdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZFBUcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:32:55 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:54964 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZFBUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:32:55 -0400
Subject: Re: [RFC PATCH 1/1] smi_detector: A System Management Interrupt
 detector
From: Jon Masters <jonathan@jonmasters.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
In-Reply-To: <20090602183231.GA13213@linux.vnet.ibm.com>
References: <20090531163117.502167374@jonmasters.org>
	 <20090531163343.771922592@jonmasters.org>
	 <20090602183231.GA13213@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 02 Jun 2009 16:32:31 -0400
Message-Id: <1243974751.31439.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 11:32 -0700, Paul E. McKenney wrote:
> On Sun, May 31, 2009 at 12:31:18PM -0400, Jon Masters wrote:
> > This patch introduces a new SMI (System Management Interrupt) detector module
> > that can be used to detect high latencies within the system. It was originally
> > written for use in the RT kernel, but has wider applications.
> 
> This would have been extremely handy a few years back when we were
> chasing some latency issues!!!  ;-)

Thanks. One guy on IRC already asked why it didn't find all his SMIs.
I'll add to the docs that this can obviously only detect when it's
sampling - since we can't constantly sample without "locking up" the
machine, it's a tradeoff. The defaults are intended so you could put
them on a laptop and not notice - in practice, I've been running with 1
second window size and .5 second sample width - i.e. very meaty and
highly disruptive, but great at catching the little so and sos :)

> I don't see how this handles CPU hotplug operations (see interspersed),
> but I am OK with "don't do CPU-hotplug operations while running this
> test."

It doesn't, good catch. Though in fairness, I don't think that's big
issue - but having said that, the ring_buffer handles cpu hotplug nicely
and I just need to think a bit harder, so I'll possibly do that in my
next v3 posting...gonna go get that one ready now.

Thanks guys,

Jon.


