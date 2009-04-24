Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbZDXIkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbZDXIkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZDXIkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:40:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51432 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZDXIki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:40:38 -0400
Date: Fri, 24 Apr 2009 10:44:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Damato <ice799@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
Message-ID: <20090424084419.GH13896@one.firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com> <49EFC8FE.7010403@zytor.com> <3605561d0904231422s57bd4cedl722be1dabf27428f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3605561d0904231422s57bd4cedl722be1dabf27428f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> gcc 4.2.4 - withOUT memset patch: 20
> gcc 4.2.4 - with memset patch: 365
> 
> gcc 3.4 - withOUT memset patch: 17
> gcc 3.4 - with memset patch: 349

Yes it sounds like 3.4 is worse on that than 3.2. Too bad.

> I'm guessing this is probably not acceptable, so I won't bother

It depends if the calls are in critical code. Or how big they
are (for a 1K memset it's totally fine to have it out of line).

For example for any memsets in __init functions we wouldn't
care. You could filter those out. And perhaps eyeball the code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
