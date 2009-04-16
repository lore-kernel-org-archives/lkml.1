Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZDPQ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZDPQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZDPQ57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:57:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44502 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbZDPQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:57:58 -0400
Date: Thu, 16 Apr 2009 18:56:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v3
Message-ID: <20090416165640.GA13927@elte.hu>
References: <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org> <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 16 Apr 2009, Jesse Barnes wrote:
> > 
> > Any comments on this one, Linus?  Should I include your ack?
> 
> I'm not ready to ack it, no. I don't think the suggested patch is very 
> clean or necessarily sensible as-is. It seems very ad-hoc. 
> 
> I was literally thinking of something like 
>  "round up from the last RAM by X"
>  "round up from the last reserved region by Y"
>  "pick the bigger of the two"
> 
> with helper functions for the two cases and comments along the 
> lines of why we do it. Something that was a bit more obvious about 
> what it's doing and why.

That's sensible - but i'd also like to inject hpa's add-on idea: if 
we do that then we should do it _explicitly_ and _visibly_, by 
injecting an artificial e820 reservation range to all expected 
"vulnerable" holes we cannot fully trust.

We'd do that after all the fixed resources are allocated, but before 
dynamic PCI allocations.

That prevents the PCI layer from dynamically allocating anything 
into that protective zone, and documents it as well (and makes it 
visible in boot logs, etc.) - instead of just a silent rule 
somewhere that no-one will really see if it breaks.

Or would this be a bad idea for some obvious reason i missed?

	Ingo
