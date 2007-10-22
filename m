Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXJVUNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXJVUNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbXJVUNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:13:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51550 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbXJVUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:13:34 -0400
Date: Mon, 22 Oct 2007 21:16:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071022211617.31f5c63d@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
	<1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
	<Pine.LNX.4.64.0710222137520.7105@anakin>
	<alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 12:49:40 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 22 Oct 2007, Geert Uytterhoeven wrote:
> >
> > Better safe than sorry...
> > 
> > Is it possible that a chain entry pointer has bit 1 set on architectures
> > (e.g. m68k) where the natural alignment of 32-bit quantities is _2_ bytes,
> > not 4?
> 
> Better make sure that such alignment never happens... But no, I don't 
> think it will, since these things would generally always have to be 
> allocated with an allocator, and the *allocator* won't return 2-byte 
> aligned data structures.

No - but a structure which has other objects in it before the object
being written out may well be 2 byte aligned on M68K and some of the
other externally 16bit platforms - ditto local dynamic objects.

Why can't we just make the list one item longer than the entry count and
stick a NULL on the end of it like normal people ? Then you need one bit
which ought to be safe for everyone (and if the bit is a macro any CPU
warped enough to have byte alignment is surely going to have top bits
spare...)

Alan
