Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbZCBNWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbZCBNWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZCBNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:22:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:43617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZCBNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:22:36 -0500
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jonathan@jonmasters.org
In-Reply-To: <49A94032.9010105@s5r6.in-berlin.de>
References: <20090226131336.423054348@linutronix.de>
	 <20090226131719.760899560@linutronix.de>
	 <20090226153216.5db66bc3.akpm@linux-foundation.org>
	 <20090226212752.332ba546@infradead.org>
	 <20090226214514.f8a58731.akpm@linux-foundation.org>
	 <1235719113.4948.1252.camel@laptop>
	 <20090226234800.4977fca5.akpm@linux-foundation.org>
	 <1235721910.4948.1321.camel@laptop> <20090227070633.2c3fc04e@infradead.org>
	 <alpine.DEB.2.00.0902271024160.25593@gandalf.stny.rr.com>
	 <49A94032.9010105@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 14:21:48 +0100
Message-Id: <1236000108.5330.384.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 14:46 +0100, Stefan Richter wrote:
> > We also tried to bind the IRQ thread to the CPU if it were to run a 
> > softirq. But that too had issues. If the IRQ thread was bound to a CPU and 
> > a higher priority process preempted it, that IRQ handler could not migrate 
> > to another CPU to finish the work. Now the IRQ handler would need to wait 
> > for that high priority process to give up the CPU in order to continue.
> > 
> > The solution is to redesign the softirq code to handle migration.
> 
> Do you mean "redesign the softirq framework" or "redesign the softirq
> framework users"?
> 
> (In the particular case of firewire, the latter should be just fine.)

The latter.

