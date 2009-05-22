Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZEVTRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZEVTRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZEVTRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:17:13 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:40874 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZEVTRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:17:11 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 14:17:08 -0500
User-Agent: KMail/1.9.9
References: <200905221139.26941.lkml@morethan.org> <20090522183622.GA8385@elte.hu>
In-Reply-To: <20090522183622.GA8385@elte.hu>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221417.10645.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, you wrote:
> 
> * Michael S. Zick <lkml@morethan.org> wrote:
> 
> > Found in the bit-rot for 32-bit, x86, Uni-processor builds:
> > 
> > diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> > index f6aa18e..3c790ef 100644
> > --- a/arch/x86/include/asm/alternative.h
> > +++ b/arch/x86/include/asm/alternative.h
> > @@ -35,7 +35,7 @@
> >                 "661:\n\tlock; "
> > 
> >  #else /* ! CONFIG_SMP */
> > -#define LOCK_PREFIX ""
> > +#define LOCK_PREFIX "\n\tlock; "
> >  #endif
> 
> What is your motivation for this change? At first sight this makes 
> the UP kernel a bit larger and a bit smaller. Are you fixing some 
> real regression/bug here?
>

Yes - but not easy to test for unless you have hardware that can
generate an interrupt flood for long enough period of time to
catch the atomic ops inbetween the read bus cycle and the write
bus cycle - a very small window.

As luck (good? bad? ugly?) would have it, I have a SDHC card and
machine organization that will trigger a flood from the ehci_hcd driver.
A poor man's test setup.

Even with that bit of luck, it takes from minutes to hours to hit the window.
The single lockdep dump I posted was the result of nearly a month's testing.
It is a _small_ window.  ;)

Mike
> 	Ingo
> 
> 


