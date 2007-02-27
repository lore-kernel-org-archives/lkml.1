Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbXB0KVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbXB0KVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbXB0KVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:21:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:55358 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbXB0KVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:21:49 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070227073815.GA25894@Krystal>
References: <1164585589.16871.52.camel@localhost.localdomain>
	 <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com>
	 <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
	 <20070227035456.GA15444@Krystal>
	 <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu>
	 <20070227073815.GA25894@Krystal>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 02:18:55 -0800
Message-Id: <1172571535.5517.222.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 02:38 -0500, Mathieu Desnoyers wrote:

> 
> I am concerned about the automatic fallback to the PIT when no other
> clock source is available. A clocksource read would be atomic when TSC
> or HPET are available, but would fall back on PIT otherwise. There
> should be some way to specify that a caller is only interested in atomic
> clock sources (if none are available, the call should simply return an
> error, or 0).
> 
> I still think that an RCU style update mechanism would be a good way  to
> fix the current clocksource read issue. Another, slower and non NMI
> safe way to do this would be with a read seqlock and with IRQ disabling.

I'm not sure what you mean by using the RCU, but the pit clocksource
does disable interrupts with a spin_lock_irqsave().

Daniel

