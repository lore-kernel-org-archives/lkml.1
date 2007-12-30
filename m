Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbXL3PKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbXL3PKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbXL3PKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:10:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60096 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbXL3PKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:10:05 -0500
Date: Sun, 30 Dec 2007 16:06:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - RFC] x86: unify arch/x86/kernel/Makefile(s)
Message-ID: <20071230150602.GU16946@elte.hu>
References: <20071230082952.GA12327@uranus.ravnborg.org> <20071230145517.GT16946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230145517.GT16946@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Combine the 32 and 64 bit specific Makefiles in one file. While 
> > doing so link order was (almost) preserved on 32 bit but on 64 bit 
> > link order changed a lot.
> > 
> > Patch was checked with defconfig + allyesconfig builds. The same .o 
> > files were linked in these configurations.
> > 
> > To keep readability of the Makefiles a few Kconfig symbols was 
> > added/modified and it was checked that they were not used anywhere 
> > else.
> 
> hm, i agree with this change, but would it be possible to split this 
> up into gradual steps, to change the rules on 64-bit one by one? That 
> would make it much more bisectable. In our experience changes to the 
> link order have a high likelyhood of breaking stuff, as we've got so 
> many implicit initcall dependencies that are not explicitly spelled 
> out.

i've added your full patch meanwhile - maybe we can get away with it. 

Still, if you see any easy way to do a straightforward series of ~40 
patches that changes one link rule per patch then that would be great 
and we could add them as an easier-to-bisect replacement for this one 
large-scope patch.

	Ingo
