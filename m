Return-Path: <linux-kernel-owner+w=401wt.eu-S969648AbXFHWYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969648AbXFHWYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXFHWYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:24:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45706 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbXFHWYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:24:46 -0400
Date: Fri, 8 Jun 2007 23:28:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608232859.37be1902@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706081448330.5795@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com>
	<B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
	<20070607151243.22caab9e.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
	<466864F8.2050903@cosmosbay.com>
	<46686810.6030805@redhat.com>
	<Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
	<466880A4.3090908@redhat.com>
	<Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
	<20070608120746.GD12687@thunk.org>
	<20070608140150.6f31672f@the-village.bc.nu>
	<Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
	<20070608192652.4a291901@the-village.bc.nu>
	<4669A351.4010403@redhat.com>
	<20070608203007.3c50eb66@the-village.bc.nu>
	<Pine.LNX.4.64.0706081229030.5795@alien.or.mcafeemobile.com>
	<20070608204836.5adaefa7@the-village.bc.nu>
	<Pine.LNX.4.64.0706081246360.5795@alien.or.mcafeemobile.com>
	<20070608222437.540bd8a6@the-village.bc.nu>
	<Pine.LNX.4.64.0706081448330.5795@alien.or.mcafeemobile.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Unproven and dubious at best as a claim.
> 
> I really don't mean to be rude and pointing you to read the archives, but 
> the proof and the reason why claims are valid is inside there.

I've read the archive. I'm totally unconvinced by any of the fd
allocation policy stuff. There are some good arguments about O_CLOEXEC
and threading but not about fd allocation.
 
> > > It does not work. What if the main application, library A and library B 
> > > wants to implement their own allocation strategy?
> > 
> > Its called "discipline". I would suggest that libc contains a default
> > allocator. You might also want to assign library and application ranges
> > for clarity.
> 
> That is really nice solution. Each library has to have each own allocator. 

Are you being deliberately stupid ?

I suggested *libc* contains a default allocator

> Then we'll have what, a committee that assigns fd ranges?

Currently the fd ranges are assigned by a committee called POSIX based on
Unix practice.

> replicated all around the code that access directly the fdtables. I did 
> the fdmap consolidation patch, and I can tell you there are quite a few 
> places that access fdtables directly.

This is true, but if you are worried about complexity we get back to the
original posix allocator which packs them in tight and produces a most
excellent spread in the general case (whacko apps like bash aside)

