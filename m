Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYCNVkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYCNVkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYCNVjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:39:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43291 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbYCNVjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:39:53 -0400
Date: Fri, 14 Mar 2008 22:42:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
Message-ID: <20080314214205.GW2522@one.firstfloor.org>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314195520.GV2522@one.firstfloor.org> <1205530409.27413.1242484373@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205530409.27413.1242484373@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 10:33:29PM +0100, Alexander van Heukelum wrote:
> static inline int fls64(__u64 x)
> {
>         __u32 h = x >> 32;
>         if (h)
>                 return fls(h) + 32;
>         return fls(x);
> }
> 
> I just wanted to move the 64-bit version to that header, with some
> ifdefs to select the right one.

That's still far more than the single 64bit instruction fls64 uses

> In fact I just found out that it only had an effect for 64 bit
> machines. Still, setting it unconditionally feels wrong.

I don't think your feeling is correct.

> 
> > > x86_64 has a mysterious inline function set_bit_string, which is
> > > only used by pci-calgary_64.c and pci-gart_64.c. Not sure what to
> > > do with it.
> > 
> > It's generic and could really live in linux/bitops.h
> 
> It could. But it is a trivial (slow?) implementation. Probably fine

It is this way because the callers in 95+% of all cases only
set a single bit. For that case it is not slow.

-Andi
