Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYCCQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYCCQCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYCCQCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:02:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52584 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466AbYCCQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:02:43 -0500
Date: Mon, 3 Mar 2008 15:48:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
Message-ID: <20080303154831.22a4eb14@core>
In-Reply-To: <20080303120842.GA28369@elf.ucw.cz>
References: <20080225090316.GA420@elf.ucw.cz>
	<Pine.LNX.4.44L0.0802250943410.3549-100000@iolanthe.rowland.org>
	<20080303120842.GA28369@elf.ucw.cz>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, so linux actually atomicity of long?

No it doesn't. And even if it did you couldn't use long for this because
atomic_t also ensures the points operations complete are defined. You
might just about get away with volatile long * objects on x86 for simple
assignments but for anything else gcc can and will generate code to
update values whichever way it feels best - which includes turning

	long *x = a + b;

into

	*x = a;
	*x += b;

Alan
