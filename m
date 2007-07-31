Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbXGaJF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbXGaJF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXGaJFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:05:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56266 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420AbXGaJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:05:14 -0400
Date: Tue, 31 Jul 2007 10:11:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
Message-ID: <20070731101133.5ae6ac79@the-village.bc.nu>
In-Reply-To: <20070731085713.GA15136@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	<1185536610.502.8.camel@localhost>
	<20070729170641.GA26220@elte.hu>
	<1185839164.27166.7.camel@localhost>
	<1185863461.3092.4.camel@twins>
	<20070731085713.GA15136@elte.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> code runs under the BKL, and the only other major kernel infrastructure 
> that has BKL dependencies is the TTY code. Kasper, as a debugging 

And half the ioctls some of which trigger long code sections.

For the tty layer I'm waiting for the revoke code to get finished up and
move from -mm into Linus tree. At that point the real evil lock_kernel
related stuff in the tty layer can switch to using the revoke code for
hangup paths and then other bits can be tackled.

Alan
