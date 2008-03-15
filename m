Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYCORyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYCORyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 13:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYCORyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 13:54:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34914 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbYCORyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 13:54:11 -0400
Message-Id: <1205603650.19648.1242579149@webmail.messagingengine.com>
X-Sasl-Enc: yqKGXWB4+YwsjcRo3Gc4VO3AG0ahcMaeveBmNzxXVxLW 1205603650
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org>
   <1205523826.7441.1242464129@webmail.messagingengine.com>
   <20080314195520.GV2522@one.firstfloor.org>
   <1205530409.27413.1242484373@webmail.messagingengine.com>
   <20080314214205.GW2522@one.firstfloor.org>
   <1205532078.32744.1242485965@webmail.messagingengine.com>
   <20080314221845.GX2522@one.firstfloor.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
In-Reply-To: <20080314221845.GX2522@one.firstfloor.org>
Date: Sat, 15 Mar 2008 18:54:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 14 Mar 2008 23:18:45 +0100, "Andi Kleen" <andi@firstfloor.org>
said:
> > #else
> > static inline int fls64(__u64 x)
> > {
> >         if (x == 0)
> >                 return 0;
> >         return __fls(x) + 1;
> 
> That would require a polymorphic macro __fls that adapts to 32bit and
> 64bit arguments.  Not good C style.

Hi Andi,

It's unsigned long __fls(unsigned long)... and this is only compiled
if unsigned long is as long as u64. Seems fine to me. Moreover, it
is _exactly_ how it is done in x86_64 now. I must be missing something.

> > This is the only reason that this define exists. With another
> > name it would be fine. HWEIGHT_USE_MULTIPLIER?
> 
> AFAIK it only exists because some ancient sparc chips had incredibly
> slow multipliers.

Good to know. And I realized that there is also the machines without
a hardware multiply instruction at all. So you are right. i386/x86_64
should just unconditionally set ARCH_HAS_FAST_MULTIPLIER.

> > And my feeling is that this is exactly the reason why this is
> > not a good version for a generic implementation in bitops.h. But
> > I don't care much.
> 
> I bet most different approaches who might be slightly
> faster for larger bit strings would make the one bit 
> case slower.

That is true, of course. But then the name of the function should
give a hint that it is optimized for short sequences.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

