Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZDWGIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZDWGIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZDWGIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:08:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41546 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZDWGIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:08:41 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: fresh data was Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
From: Andi Kleen <andi@firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu>
	<8763gxoz50.fsf_-_@basil.nowhere.org>
	<alpine.LFD.2.00.0904221354320.3101@localhost.localdomain>
	<20090422211501.GD13896@one.firstfloor.org>
	<alpine.LFD.2.00.0904221417110.3101@localhost.localdomain>
	<20090422220428.GE13896@one.firstfloor.org>
Date: Thu, 23 Apr 2009 08:08:38 +0200
In-Reply-To: <20090422220428.GE13896@one.firstfloor.org> (Andi Kleen's message of "Thu, 23 Apr 2009 00:04:28 +0200")
Message-ID: <87skjzoqah.fsf_-_@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> > Quick test here:
>> 
>> How about you just compile the kernel with gcc-3.2 and compare the number 
>> of calls to memcpy before-and-after instead? That's the real test.
>
> I waited over 10 minutes for the full vmlinux objdumps to finish. sorry lost
> patience. If someone has a fast disassembler we can try it. I'll leave
> them running over night, maybe there are exact numbers tomorrow.
>
> But from a quick check (find -name '*.o' | xargs nm | grep memcpy) there are
> very little files which call it with the patch, so there's some
> evidence that there isn't a dramatic increase.

I let the objdumps finish over night. On my setup (defconfig + some 
additions) there are actually less calls to out of line memcpy/__memcpy
with the patch. I see only one for my defconfig, while there are 
~10 without the patch. So it makes very little difference.
The code size savings must come from more efficient code generation
for the inline case. I haven't investigated  that in detail though.

So the patch seems like a overall win.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
