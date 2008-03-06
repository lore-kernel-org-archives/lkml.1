Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbYCFPyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbYCFPyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYCFPyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:54:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759504AbYCFPyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:54:13 -0500
Date: Thu, 6 Mar 2008 16:52:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Srinivasa DS <srinivasa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 - Enhance DEBUG_RODATA support - alternatives
Message-ID: <20080306155238.GA24008@elte.hu>
References: <20080306140105.GC28438@elte.hu> <47D014E1.30964.22A9390F@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D014E1.30964.22A9390F@pageexec.freemail.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> > +		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> > +		WARN_ON(!vaddr);
> > +		local_irq_save(flags);
> > +		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> > +		local_irq_restore(flags);
> 
> you probably want a BUG_ON instead (or some graceful recovery) else 
> the NULL deref will trigger with IRQs off...

agreed - i changed it to BUG_ON() for the time being.

	Ingo
