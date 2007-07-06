Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbXGFRMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbXGFRMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbXGFRMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:12:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42974 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbXGFRMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:12:00 -0400
Date: Fri, 6 Jul 2007 19:11:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070706171159.GB8174@one.firstfloor.org>
References: <20070705215152.GA4865@Krystal> <p73myy9215m.fsf@bingen.suse.de> <20070706144144.GC32754@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706144144.GC32754@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 10:41:44AM -0400, Mathieu Desnoyers wrote:
> I haven't thought about making it the default for kernel space
> preemption, but yes, it would make sense.

Now it's too late -- getcpu() has infected the kernel everywhere.
It would have made sense a few years ago.


> ... getcpu()...

Hmm ok, although i suspect it's rare to assume that. But understood
you don't want to audit all getcpu users because of this.

> using a short instead of an int on modern x86 will cause pipeline stalls
> due to partial register use.

Sorry, that's totally bogus. Primarily because the access would be directly
on memory and there is no partial register tracking there.

Besides pipeline stall is not the correct description on what would
happen if you used a register, the worst you get is a single false dependency
but no pipeline flush.

Besides the latest x86 cpus (C2, K8) don't have much trouble with these
false dependencies in general.

> usage, since it is followed by an unsigned long; gcc structure alignment


> will put padding instead of the integer, which does not buy us anything

on i386 unsigned long is 4 bytes.

-Andi
