Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYCNWQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYCNWQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYCNWQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:16:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYCNWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:16:33 -0400
Date: Fri, 14 Mar 2008 23:18:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
Message-ID: <20080314221845.GX2522@one.firstfloor.org>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314195520.GV2522@one.firstfloor.org> <1205530409.27413.1242484373@webmail.messagingengine.com> <20080314214205.GW2522@one.firstfloor.org> <1205532078.32744.1242485965@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205532078.32744.1242485965@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> #else
> static inline int fls64(__u64 x)
> {
>         if (x == 0)
>                 return 0;
>         return __fls(x) + 1;

That would require a polymorphic macro __fls that adapts to 32bit and 64bit
arguments.  Not good C style.

> This is the only reason that this define exists. With another
> name it would be fine. HWEIGHT_USE_MULTIPLIER?

AFAIK it only exists because some ancient sparc chips had incredibly
slow multipliers.

> And my feeling is that this is exactly the reason why this is
> not a good version for a generic implementation in bitops.h. But
> I don't care much.

I bet most different approaches who might be slightly
faster for larger bit strings would make the one bit 
case slower.

-Andi

