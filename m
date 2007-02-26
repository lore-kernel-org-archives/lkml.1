Return-Path: <linux-kernel-owner+w=401wt.eu-S1030505AbXBZVU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505AbXBZVU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933803AbXBZVU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:20:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800AbXBZVU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:20:28 -0500
Date: Mon, 26 Feb 2007 13:14:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@gmail.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Stephane Eranian <eranian@hpl.hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
In-Reply-To: <45E3493C.1040706@gmail.com>
Message-ID: <Pine.LNX.4.64.0702261308490.12485@woody.linux-foundation.org>
References: <20070226180635.GA644@tv-sign.ru>
 <Pine.LNX.4.64.0702261006440.12485@woody.linux-foundation.org>
 <45E3493C.1040706@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Rene Herman wrote:
> 
> Other than these two, ECP parallel ports are the other remaining users.
> Now, even though on a machine that still has a parallel port it might usually
> indeed be set to ECP in its BIOS; having anything attached to the port also
> use it as such seems quite seldom.

Well, if it's some kind of cache coherency problem (the same way much more 
modern CPU's have cache coherency issues with DMA during C3 sleep), then 
it's entirely possible that the normal ECP parallel port behaviour would 
never show it, since most people tend to use it for output only (yeah, I 
realize you can use it bidirectionally, but at least on old hardware it 
tends to be "talk AT printer" rather than "talk WITH printer".

I frankly forget what hardware platforms had problems with the DMA thing, 
and what the exact behaviour even was (I think there was some possibility 
of corrupt data on the floppy). We also used to have the "nohlt" flag to 
turn off hlt entirely, and that was due to some other legacy issues, iirc.

I seriously doubt we will ever see anybody who has this problem ever 
again, but on the other hand, I also seriously doubt that most modern 
machines even *have* a floppy drive any more, so I'd rather not even 
change it. It's just not worth even a miniscule risk..

		Linus
