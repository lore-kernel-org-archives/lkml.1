Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYBIJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYBIJlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYBIJku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:40:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYBIJkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:40:49 -0500
Date: Sat, 9 Feb 2008 10:40:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: davej@codemonkey.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080209094037.GA23418@elte.hu>
References: <20080207190241.GA9449@basil.nowhere.org> <20080207191337.GA13111@elte.hu> <20080207200308.GA26555@one.firstfloor.org> <20080207203705.GA19083@elte.hu> <20080208114419.GB4745@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208114419.GB4745@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > because it's not just an open-coded __tlb_flush_all(), it _disables PGE 
> > and keeps it so while the MTRR's are changed on all CPUs_.
> 
> Yes and? 

your first patch was outright wrong then you declared the second one a 
"cleanup" while it changes behavior: bad in my book ;-)

> > Your patch adds __flush_tlb_all() which re-enables the PGE bit in cr4, 
> > see asm-x86/tlbflush.h:
> > 
> >         /* clear PGE */
> >         write_cr4(cr4 & ~X86_CR4_PGE);
> >         /* write old PGE again and flush TLBs */
> >         write_cr4(cr4);
> > 
> > so we'll keep PGE enabled during the MTRR setting - which changes 
> > behavior.
> 
> It changes behaviour in some minor ways but I don't think it makes any 
> difference. PGE only influences TLB flushes (according to its 
> specification) and all the TLB flushes still run with PGE disabled.

now that i pointed out the difference, your position changed to "changes 
behavior in minor ways" ;-)

This is fragile code and almost nothing in the MTRR area is "minor", we 
are just not touching this code unless it's really justified.

	Ingo
