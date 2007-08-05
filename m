Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbXHEUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbXHEUFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXHEUF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:05:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53145 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756750AbXHEUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:05:25 -0400
Date: Sun, 5 Aug 2007 21:04:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>, Jeff Garzik <jeff@garzik.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [patch] implement smarter atime updates support
Message-ID: <20070805210446.57aa66f6@the-village.bc.nu>
In-Reply-To: <1186343582.25667.3.camel@laptopd505.fenrus.org>
References: <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	<46B4C0A8.1000902@garzik.org>
	<20070805102021.GA4246@unthought.net>
	<46B5A996.5060006@garzik.org>
	<20070805105850.GC4246@unthought.net>
	<20070805124648.GA21173@elte.hu>
	<alpine.LFD.0.999.0708050944470.5037@woody.linux-foundation.org>
	<20070805190928.GA17433@elte.hu>
	<20070805192226.GA20234@elte.hu>
	<1186343582.25667.3.camel@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> you might want to add
> 
> 	/* 
> 	 * if the inode is dirty already, do the atime update since
> 	 * we'll be doing the disk IO anyway to clean the inode.
> 	 */
> 	if (inode->i_state & I_DIRTY)
> 		return 1;

This makes the actual result somewhat less predictable. Is that wise ?
Right now its clear what happens based on what user sequence of events
and that this is easily repeatable.
