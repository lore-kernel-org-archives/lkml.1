Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZDWWNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZDWWNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZDWWNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:13:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbZDWWNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:13:00 -0400
Message-ID: <49F0E6FD.8030108@zytor.com>
Date: Thu, 23 Apr 2009 15:09:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re:
 	New x86 warning
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu>	 <8763gxoz50.fsf_-_@basil.nowhere.org>	 <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com>	 <49EFC8FE.7010403@zytor.com> <3605561d0904231422s57bd4cedl722be1dabf27428f@mail.gmail.com>
In-Reply-To: <3605561d0904231422s57bd4cedl722be1dabf27428f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
> 
> Looks like this thread is dead/dying, but figured I should reply with
> my test findings. The number of out-of-line calls (as determined by:
> make mrproper && make defconfig && make && objdump -d vmlinux | grep
> "call.*\<memset" | wc -l))
> 
> gcc 4.2.4 - withOUT memset patch: 20
> gcc 4.2.4 - with memset patch: 365
> 
> gcc 3.4 - withOUT memset patch: 17
> gcc 3.4 - with memset patch: 349
> 
> I'm guessing this is probably not acceptable, so I won't bother
> installing/trying gcc-3.2 unless anyone thinks that a 300+ increase in
> out-of-line calls is OK.
> 

Not unless it can be proven those calls are in non-performance-critical 
contexts.  That's a lot of work to go through, though.

	-hpa

