Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZBCVUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZBCVUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZBCVT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:19:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbZBCVT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:19:59 -0500
Date: Tue, 3 Feb 2009 13:18:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <20090203210442.GA27804@elte.hu>
Message-ID: <alpine.LFD.2.00.0902031313290.3247@localhost.localdomain>
References: <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain>
 <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain> <20090203195304.GA31049@elte.hu> <alpine.LFD.2.00.0902031209280.3247@localhost.localdomain> <20090203205727.GA4460@elte.hu> <20090203210442.GA27804@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Ingo Molnar wrote:
> 
> So i'd still like your tentative Signed-off-by for your patch - it's i think 
> not v2.6.29 material but if it stays problem free in testing we can try it 
> in v2.6.30. If it causes problem it will be clearly bisectable and clearly 
> revertable.

Hmm. You can have my sign-off, because I certainly don't think the patch 
is _wrong_, but I also don't think it's necessarily really worth it unless 
somebody can show a real upside. As mentioned, I don't think this matters 
in practice for the whole MSI suspend issue - doing the "mask()" thing 
feels stupid and certainl;y wasn't what I expected us to do, but it really 
shouldn't matter from an actual behavioural standpoint at all.

And if, as you say, we don't expect to have interrupts spread out across 
CPUs (and with the current io-apic they certainly don't happen - I don't 
know about x2apic) my performance arguments are bogus too.

So the patch probably is the right thing to do, but the upsides are slim 
to nonexistent, and the downside you pointed out of somebody using that 
"handle_edge_irq()" thing with an interrupt that turns out to be level 
after all makes me worry a bit.

But feel free to put it in some experimental branch with my sign-off.

		Linus
