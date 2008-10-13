Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYJMPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYJMPn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYJMPnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:43:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754916AbYJMPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:43:17 -0400
Date: Mon, 13 Oct 2008 16:40:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Karel Zak <kzak@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
Message-ID: <20081013164000.04fab4c2@lxorguk.ukuu.org.uk>
In-Reply-To: <20081013152633.GA6523@elte.hu>
References: <20081004174433.14a5e093@infradead.org>
	<20081004215225.2444d54b.akpm@linux-foundation.org>
	<20081005081145.30ba921b@infradead.org>
	<20081005102742.de8353b4.akpm@linux-foundation.org>
	<20081005103826.6771540a@infradead.org>
	<20081012200004.GI10429@nb.net.home>
	<alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org>
	<20081013152633.GA6523@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The warning occurs because hwclock uses this dubious sequence of
> code to run "atomic" code:

Nobody should be using old versions of hwclock that do this as they are
not SMP safe.

> So instead just enable interrupts in the pagefault path unconditionally
> if we come from user-space, and handle the fault.

This should definitely also log an error to get users to remove that
rubbish from their PC
