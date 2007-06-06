Return-Path: <linux-kernel-owner+w=401wt.eu-S936282AbXFFXPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936282AbXFFXPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935964AbXFFXPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:15:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50727 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935900AbXFFXPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:15:04 -0400
Date: Thu, 7 Jun 2007 00:19:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070607001932.35c9591c@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	prctl(PR_SPARSEFD, 1);
> > 
> > to turn on sparse fd allocation for a process ?
> 
> There was a little discussion where I tried to whisper something similar, 
> but Linus and Uli shot me :) - with good reasons IMO.
> You may link to runtimes that are not non-sequentialfd aware, and will 
> break them.

Linking to the correct version of a libary and getting the library
versioning right is not rocket science and isn't a sane excuse. Its no
different to the stdio to large fd migration issues with many Unixen and
they all coped just fine.

Really all this new syscall hackery stuff is just too ugly to live. If
you use the prctl then yes we have a bit of library versioning to worry
about for the odd library that cares but thats a once over thing. The
crappy zillion extra syscalls we have to support for years and years just
to save a little bit of userspace work.

At its most moronic its no different to 32 and 64bit binary linking - and
the gnu tools manage to cope with stopping me linking a 32bit app to a
64bit lib and vice versa just fine, so I'm sure they can cope the same
way with sparse fd safe/non sparese fd safe libraries

