Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYHMUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYHMUOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbYHMUOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:14:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757618AbYHMUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:14:19 -0400
Date: Wed, 13 Aug 2008 13:13:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: ebiederm@xmission.com, ying.huang@intel.com, pavel@ucw.cz,
       nigel@nigel.suspend2.net, rjw@sisk.pl, vgoyal@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
In-Reply-To: <20080813130749.c406ab6c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808131310450.3462@nehalem.linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com> <alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org> <m1r68shjhb.fsf@frodo.ebiederm.org> <20080813124406.21091eae.akpm@linux-foundation.org> <alpine.LFD.1.10.0808131247320.3462@nehalem.linux-foundation.org>
 <20080813130749.c406ab6c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Andrew Morton wrote:
> > 
> > Nope. That needs to be an "unsigned long".
> 
> It is.

Gaah. I just misread the patch, sorry.

> Used a bitop to preserve the runtime checking in there.  spin_unlock()
> doesn't return the previous lockedness.

Umm. spin_unlock does a lot more when you have lock debugging on, and 
doesn't do useless crap when it isn't.

> A bitop seems a better fit to me.  We never spin on that lock (it
> always uses test_and_set), so why use a "spin"lock?

..because an atomic bitop is not the same as a lock.

The memory ordering guarantees are different. Yes, they are sufficient, 
but that's because we've had to make them so to account for CRAP CODE that 
uses bit operations as if they were locks.

Don't continue that. It's WRONG.

		Linus
