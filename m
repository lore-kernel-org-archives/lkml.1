Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356Ab0AMEOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab0AMEOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 23:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500Ab0AMEOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 23:14:52 -0500
Received: from ozlabs.org ([203.10.76.45]:55303 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab0AMEOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 23:14:51 -0500
Date: Wed, 13 Jan 2010 15:14:45 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Entry conditions for perf_event_do_pending?
Message-ID: <20100113041445.GA17829@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're seeing some perf-related crashes on powerpc related to having
irqs in an inconsistent state (soft-enable vs. hard-enable
vs. trace-irqs state) when entering perf_event_do_pending().
We're fixing that, but along the way we have struck a question about
what conditions are required on entry to perf_event_do_pending.

Its use of __get_cpu_var implies that it at least needs to be called
with either interrupts or preemption disabled.  Does it in fact need
to be called with irqs off?  Do we need to call irq_enter()/irq_exit()
around it?  Are there any other requirements that people can think of?

Paul.
