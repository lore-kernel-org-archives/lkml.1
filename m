Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbZKXVlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbZKXVlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933995AbZKXVlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:41:21 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57664 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933922AbZKXVlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:41:20 -0500
Date: Tue, 24 Nov 2009 15:41:21 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091124214121.GA15182@sgi.com>
References: <20091120211139.GB19106@sgi.com> <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com> <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain> <1259069986.4531.1453.camel@laptop> <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain> <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ws1f6csh.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:41:18AM -0800, Eric W. Biederman wrote:
> As for the UV code, what we are looking at is a fundamental irq
> routing property.  Those irqs cannot be routed to some cpus.  That is
> something the code that sets up the routes needs to be aware of.

Correct.  We can't allow an interrupt to be routed to an invalid node.

> Dimitri could you put your the extra code in assign_irq_vector instead
> of in the callers of assign_irq_vector?  Since the probably is not
> likely to stay unique we probably want to put the information you base
> things on in struct irq_desc, but the logic I seems to live best in
> in assign_irq_vector.

So you're saying continue to use the node value in irq_desc, or add a cpumask there (which will add some size to that structure)?  I'll have to take another look at assign_irq_vector, but as things are currently structured, we don't return any sort of valid cpumask that we'd need for further processing in the caller functions.  One would need to pass that back or store that cpumask someplace, like irq_desc?
