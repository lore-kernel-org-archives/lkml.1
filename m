Return-Path: <linux-kernel-owner+w=401wt.eu-S937617AbYD1UD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937617AbYD1UD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935443AbYD1UDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:03:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937521AbYD1UDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:03:07 -0400
Message-ID: <48162C93.3040101@zytor.com>
Date: Mon, 28 Apr 2008 12:59:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <1209329485.3801.46.camel@localhost.localdomain>	<20080427214837.GA11631@elte.hu>	<1209335660.3801.79.camel@localhost.localdomain>	<4815009C.2010809@garzik.org>	<20080428071006.5ce27533@laptopd505.fenrus.org>	<1209392948.3367.13.camel@localhost.localdomain> <20080428080700.4190f5e6@laptopd505.fenrus.org>
In-Reply-To: <20080428080700.4190f5e6@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> Cached means that the cpu, at any time, can do a speculative read to the memory.
> It also means that the cpu can then write the speculated cacheline back at any time later,
> if some speculation was going to write to the cacheline but didn't actually happen.
> (before you think this is bogus, at least AMD cpus do this and I can't vouch for Intel
> cpus never doing this).
> If the on-the-bus hardware *ever* writes to the memory without being part of the full
> cache coherence protocol it's in trouble. Big time.
> Even if it sends an invalidate first (which PCI and others just don't allow, not sure about MCA though),
> it's not enough because the cpu can just read it right back... one needs a "take for ownership" not
> an "invalidate" for this to work, and that means being part of the full protocol.
> 

Although realistically speaking, the OS *can* generally know that the 
only transactor is the CPU -- in fact, that will be the normal condition.

	-hpa
