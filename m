Return-Path: <linux-kernel-owner+w=401wt.eu-S933086AbXGZMMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbXGZMMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbXGZMLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:11:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52348 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759719AbXGZMLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:11:49 -0400
Date: Thu, 26 Jul 2007 13:18:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Masoud Sharbiani" <masouds@google.com>,
       "Kirill Korotaev" <dev@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-ID: <20070726131840.6f11a056@the-village.bc.nu>
In-Reply-To: <200707261359.46936.ak@suse.de>
References: <20070718154759.GA26425@google.com>
	<200707261146.23886.ak@suse.de>
	<20070726031406.3866ddc5.akpm@linux-foundation.org>
	<200707261359.46936.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > So you turn it on if your applications are playing up.  bfd.
> 
> You might not know applications are segfaulting. e.g. when I originally
> enabled it we found that a few obscure cases in a default system
> were occasionally segfaulting, but nobody noticed because there
> wasn't a really visible malfunction. Still fixing those made
> a better system.

There problem is that if you get something going crazy segfaulting your
logging itself can make the problem far worse. The rate limiting is as
much important to stop accidents as stop malicious attack.

> for example. Or just run the system out of memory; that will get plenty of logs
> (don't say ulimit now, you know as well as me that they are not good enough
> to prevent oom from users). Or use an unaligned a.out executable.

Zero overcommit keeps it pretty sane - most times. 

> Some of these are rate limited, but rate limiting just means it will take longer
> to fill the disk. 

Which is good news and gives you a lot longer (or your tools a lot
longer) to react and sort it out. It also avoids the disk thrashing and
performance hit you can cause.

> Anyways if you feel strongly about it then rate limit the x86-64 ones
> (Masoud's patch did this anyways); but please don't turn them off.

Its configurable easily enough so I'm not sure it matters which way it is
set, but it does need to be a -safe- default - either rate limited or off.
