Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYHOMQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYHOMQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYHOMQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:16:03 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61441 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752877AbYHOMQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:16:01 -0400
Date: Fri, 15 Aug 2008 13:15:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, tglx@linutronix.de, hpa@zytor.com,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
In-Reply-To: <20080815115147.GA32726@elte.hu>
Message-ID: <Pine.LNX.4.55.0808151303410.11843@cliff.in.clinika.pl>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com>
 <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl>
 <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com>
 <20080815115147.GA32726@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Ingo Molnar wrote:

> > >> @@ -962,7 +962,8 @@ void __init init_bsp_APIC(void)
> > >>        */
> > >>       apic_write(APIC_LVT0, APIC_DM_EXTINT);
> > >>       value = APIC_DM_NMI;
> > >> -     if (!lapic_is_integrated())             /* 82489DX */
> > >> +     /* discrete on 82489DX */
> > >> +     if (!lapic_is_integrated())
> > >>               value |= APIC_LVT_LEVEL_TRIGGER;
> > >>       apic_write(APIC_LVT1, value);
> > >>  }
> > >
> > >  Please elaborate.
> > >
> > >  Maciej
> > >
> > 
> > Hi Maciej,
> > 
> > don't really understand what do you mean. [...]
> 
> i suspect the question might have been: 'why this change'.

 Indeed -- the change just moves a comment around from the obvious place 
(where it means: "the condition true applies to the 82489DX") to elsewhere 
while rephrasing it in a way that makes me wonder: "What the hell is that 
meant to mean?"  Perhaps it is clearer to the others, but for me it is 
just obfuscation.

 I think the comment as it is is clear enough and is also clearly visible
when browsing through the source, when you want to spot all the odd bits
related to the discrete APIC.  This is no longer true after the change.  
And any more complete explanation belongs to the definition of
lapic_is_integrated().

> If that was the question, the answer would be: to unify apic_32.c and 
> apic_64.c we first use tiny little changes to bring the two files in 
> sync. Presumably, each such change is a NOP or at least very safe - and 
> clearly bisectable in the worst-case.

 If the obfuscation comes from apic_64.c, then the clean-up should be done
in th other direction IMO.  Not everything that comes from the 64-bit
variation is better than its 32-bit counterpart.

 Please note I do not question the semantic changes contained within this
patch, so the issue of bisectability or code bloat (I am assuming
lapic_is_integrated() expands to 0 on 64-bit; if not, this is clearly
asking for improvement) is irrelevant.

  Maciej
