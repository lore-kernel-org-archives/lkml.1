Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYENVbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYENVbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYENVba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:31:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35298 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750954AbYENVba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:31:30 -0400
Date: Wed, 14 May 2008 22:19:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514221957.6edb2d60@core>
In-Reply-To: <482B5614.3060203@firstfloor.org>
References: <20080514174955.GA515@elte.hu>
	<87fxsk7n7e.fsf@basil.nowhere.org>
	<20080514220034.51eae9e0@core>
	<482B5614.3060203@firstfloor.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Most?

Yes

> 
> >of the legacy users inflict that locking on other code - eg the ISN
> > use of the BKL directly impacts on the tty layer work.
> 
> So you just stick unlock_kernel()/lock_kernel() around the call
> to TTY (or similar to the entry points)

It isn't that simple - I've spent a good deal of time working on it.
There are lots of paths that rely on interactions between modules. Eg we
found stuff racing between the pid structs tty internals and procfs that
happened to be saved by the BKL.

That in itself is a problem Ingo's stuff won't help with: We have lots of
"magic" accidental, undocumented and pot luck BKL locking semantics
between subsystems that are not even visible.
