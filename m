Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYH0Wko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYH0Wko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYH0Wkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:40:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbYH0Wke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:40:34 -0400
Date: Wed, 27 Aug 2008 15:38:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <20080827230828.4285022b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <20080827230828.4285022b@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, Alan Cox wrote:
> 
> Easier just to fix it. Its a case of building everything until it
> compiles with the prototype change. Almost all stuff  will just take the
> argument initially and not use it.
> 
> Anyone else plan to do it or shall I hit all the x86 cases and post a
> patch ?

Well, I alrady reverted it, but if you actually fix unlocked_ioctl() to 
have the same calling convention as regular ioctl() then a lot of the 
noise from ioctl conversion goes away, and all that remains is literally 
just the BKL part.

Btw, why is unlocked_ioctl returning "long"? Does anybody depend on that 
too? That's another difference between the "unlocked" and the traditional 
version..

As to the "x86 cases", I think you should try to hit them all. Doing a 
"git grep unlocked_ioctl" gets 185 entries, and it looks like only 
something like 8 of them are non-x86 (3 in the arch/ directory, five in 
s390 drivers).

Of course, some of them may be drivers that aren't available on x86 for 
other reasons (ie the ARM embedded stuff), but regardless..

Anyway, the pure size of that patch makes me suspect that we might as well 
leave it until the next merge window, but if you do it and it's obviously 
totally mechanical, I'd be likely to just let it slip in early.

		Linus
