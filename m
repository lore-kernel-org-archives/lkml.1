Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbXEXNgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbXEXNgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXEXNgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:36:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34722 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757254AbXEXNga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:36:30 -0400
Date: Thu, 24 May 2007 14:41:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] $ARCH: Enable arbitary speed tty ioctls and split
 input/output speed
Message-ID: <20070524144109.7bd0f4d0@the-village.bc.nu>
In-Reply-To: <1180012135.8303.89.camel@shinybook.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<1180012135.8303.89.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 09:08:55 -0400
David Woodhouse <dwmw2@infradead.org> wrote:

> Is my mailbox (or brain) failing me, or did you just send out these
> patches for every architecture _except_ PowerPC? :)

PowerPC is one of the main ones I've not touched because it needs work
itself to sort out the IBSHIFT value and bit allocations, also because
its one of several dependant upon the asm-generic stuff (which also means
your patch won't work)

Most people copied the x86 behaviour which makes it easy to transplant.
Some are just smoking something (see ioctls.h for sh-64 and weep), others
have slightly odd behaviour for historical compatibility reasons (Sparc)

> Presumably this is because of the mess in tty_termios_encode_baud_rate
> when we fix its bogus assumptions about IBSHIFT always being defined?

It's not a bogus assumption. The current code supports

	- The old way
	- BOTHER and IBSHIFT

When PPC wants to do arbitary baud rate it needs to resolve both of the
definitions together. IBSHIFT is simply the shift you apply to the baud
bits to get the input baud bits.

Alan
