Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbXB0TlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbXB0TlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbXB0TlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:41:05 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38054 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056AbXB0TlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:41:01 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: john stultz <johnstul@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       mbligh@google.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070227190442.GA11272@Krystal>
References: <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
	 <20070227035456.GA15444@Krystal>
	 <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu>
	 <20070227073815.GA25894@Krystal>
	 <1172571535.5517.222.camel@imap.mvista.com> <20070227160206.GA2391@Krystal>
	 <1172597055.5517.233.camel@imap.mvista.com>
	 <20070227190442.GA11272@Krystal>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 11:40:24 -0800
Message-Id: <1172605224.15970.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 14:04 -0500, Mathieu Desnoyers wrote:
> __get_nsec_offset : reads clock->cycle_last. Should be called with
> xtime_lock held. (ok so far, but see below)
> 
> change_clocksource
> clock->cycle_last = now; (non atomic 64 bits update. Not protected by
> any lock ?) -> this would race with __get_nsec_offset ?

Minor nit (it could probably use a comment fixup): its only called from
update_wall_time, which holds xtime_lock. 

> update_wall_time
> Called from timer interrupt. Holds xtime_lock and has a priority higher
> than other interrupts. Other clock->cycle_last protected by
> write_seqlock_irqsave.

-john

