Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZEVTUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZEVTUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbZEVTUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:20:10 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:42718 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbZEVTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:20:09 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 14:20:06 -0500
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <20090522183622.GA8385@elte.hu> <4A16F62B.40207@zytor.com>
In-Reply-To: <4A16F62B.40207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221420.09208.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Michael S. Zick <lkml@morethan.org> wrote:
> > 
> >> Found in the bit-rot for 32-bit, x86, Uni-processor builds:
> >>
> >> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> >> index f6aa18e..3c790ef 100644
> >> --- a/arch/x86/include/asm/alternative.h
> >> +++ b/arch/x86/include/asm/alternative.h
> >> @@ -35,7 +35,7 @@
> >>                 "661:\n\tlock; "
> >>
> >>  #else /* ! CONFIG_SMP */
> >> -#define LOCK_PREFIX ""
> >> +#define LOCK_PREFIX "\n\tlock; "
> >>  #endif
> > 
> > What is your motivation for this change? At first sight this makes 
> > the UP kernel a bit larger and a bit smaller. Are you fixing some 
> > real regression/bug here?
> > 
> 
> That looks very odd indeed.  The whole point of the LOCK_PREFIX macro is
> to squelch it on UP (locks that should not be squelched on UP should not
> be annotated LOCK_PREFIX.)
> 

OK, will inspect for that possibility.
We may just have a mis-use of LOCK_PREFIX.

Mike
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


