Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXI1RND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXI1RND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXI1RMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:12:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47910 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbXI1RMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:12:51 -0400
Date: Fri, 28 Sep 2007 18:18:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
Message-ID: <20070928181831.26f34a64@the-village.bc.nu>
In-Reply-To: <20070928165425.GA7366@wotan.suse.de>
References: <20070928154832.GB12538@wotan.suse.de>
	<20070928170719.2f617a7a@the-village.bc.nu>
	<20070928165425.GA7366@wotan.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> on the broken ppro stores config option if you just tell me what should
> be there (again, remember that my patch isn't actually changing anything
> already there except for smp_rmb side).

The PPro needs rmb to ensure a store doesn't go for a walk on the wild
side and pass the read especially when we are dealing with device space.
The rest of the stuff is a little vague which makes me nervous when
considering relaxing the PPro case for smp_rmb. With smp_rmb as it is at
the moment the PPro is effectively treated as an out of order cpu and so
shouldn't hit anything occassionally that a PPC wouldn't hit every time.

> > - and for modern processors its still not remotely clear your patch is
> > correct because of NT stores.
> 
> No. We already _have_ to rely on this model for barriers 

Well Linus has dealt with the question of NT stores for us now...

Given this isn't an issue on 64bit I'm inclined to argue that only 64bit
behaviour should be changed at this point.

Alan
