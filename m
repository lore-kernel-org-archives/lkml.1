Return-Path: <linux-kernel-owner+w=401wt.eu-S1032006AbXFHTpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032006AbXFHTpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031862AbXFHTok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:44:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41745 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031845AbXFHToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:44:38 -0400
Date: Fri, 8 Jun 2007 20:48:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608204836.5adaefa7@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706081229030.5795@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
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
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So, what do you plan to do? Those handle won't be zero-based. Your 
> "working" system I immagine will do:
> 
> 	bleeh[handle - BASE].duh = ...;
> 
> How nice for a working system. If you *store* the handle returned by the 
> OS, and you *use* the handle to call for OS services, you will be fine 
> independently from the value handed out by the OS.

Well there are two ways I'd do this

#1: Throw the whole thing away and accept its not a good idea anyway

#2: If I was really going this way and I wanted to use it for serious
tricks for high performance I/O then I'd provide the handle from
userspace so that the strategy for allocation is controlled by the caller
who is the only one who can make the smart decisions
