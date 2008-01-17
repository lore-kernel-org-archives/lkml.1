Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYAQDVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYAQDVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYAQDV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:21:28 -0500
Received: from ozlabs.org ([203.10.76.45]:36873 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYAQDV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:21:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18318.51622.37470.246611@cargo.ozlabs.ibm.com>
Date: Thu, 17 Jan 2008 14:21:10 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: john stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080117025004.GE2322@Krystal>
References: <20080115220824.GB22242@Krystal>
	<Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
	<20080116031730.GA2164@Krystal>
	<Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
	<20080116145604.GB31329@Krystal>
	<1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
	<1200523867.6127.5.camel@localhost.localdomain>
	<Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
	<1200536889.6127.52.camel@localhost.localdomain>
	<20080117024000.GD2322@Krystal>
	<20080117025004.GE2322@Krystal>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:

> Sorry for self-reply, but I thought, in the past, of a way to make this
> possible.
> 
> It would imply the creation of a new vsyscall : vgetschedperiod
> 
> It would read a counter that would increment each time the thread is
> scheduled out (or in). It would be a per thread counter

It's very hard to do a per-thread counter in the VDSO, since threads
in the same process see the same memory, by definition.  You'd have to
have an array of counters and have some way for each thread to know
which entry to read.  Also you'd have to find space for tens or
hundreds of thousands of counters, since there can be that many
threads in a process sometimes.

Paul.
