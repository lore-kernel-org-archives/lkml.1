Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYKRKiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYKRKiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 05:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYKRKiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 05:38:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYKRKh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:37:59 -0500
Date: Tue, 18 Nov 2008 11:37:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Large stack usage in fs code (especially for PPC64)
Message-ID: <20081118103726.GB31146@elte.hu>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <1226963005.7178.248.camel@pasglop> <20081118095305.GA24119@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118095305.GA24119@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Nov 18, 2008 at 10:03:25AM +1100, Benjamin Herrenschmidt wrote:
> > On Mon, 2008-11-17 at 15:34 -0500, Steven Rostedt wrote:
> > > Note, I was using a default config that had CONFIG_IRQSTACKS off and
> > > CONFIG_PPC_64K_PAGES on.
> > 
> > For one, we definitely need to turn IRQSTACKS on by default ... In fact,
> > I'm pondering just removing the option.
> 
> It shouldn't be a user-visible option.  It shouldn't on x86 either, 
> but there it always gets into the ideological 4k stacks flameware so 
> people usually gave up after a while instead of doing the sensibke 
> 8k + irqstacks by default, 4k as an option..

yep, i tend to agree that 8k + irqstacks on both 32-bit and 64-bit 
would be the sane default. There's just too much gcc and other noise 
for us to have that cushion by default on 32-bit too. 64-bit is 
already there, on 32-bit we should decouple irqstacks from 4K stacks 
and just turn irqstacks on by default.

Life's too short to fight kernel stack overflows - and now we've got 
the stack-tracer that will record and show the frame of the worst-ever 
kernel stack situation the system was in since bootup. (see Steve's 
tracer output in this thread)

	Ingo
