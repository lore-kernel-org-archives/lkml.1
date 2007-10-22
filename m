Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbXJVVmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbXJVVmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXJVVlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:41:53 -0400
Received: from [81.2.110.250] ([81.2.110.250]:50157 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750703AbXJVVlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:41:52 -0400
Date: Mon, 22 Oct 2007 22:43:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071022224343.4abf3c96@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
	<1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
	<Pine.LNX.4.64.0710222137520.7105@anakin>
	<alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
	<20071022211617.31f5c63d@the-village.bc.nu>
	<alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 13:44:43 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 22 Oct 2007, Alan Cox wrote:
> > 
> > Why can't we just make the list one item longer than the entry count and
> > stick a NULL on the end of it like normal people ? Then you need one bit
> > which ought to be safe for everyone (and if the bit is a macro any CPU
> > warped enough to have byte alignment is surely going to have top bits
> > spare...)
> 
> Well, quite frankly, equally easy is to just add a
> 
> 	__attribute__((aligned(4)))
> 
> or whatever the gcc syntax for that is today.. That guarantees that gcc 
> lays things out properly.

For structures, not array elements or stack objects. Does gcc now get
aligned correct as an attribute on a stack object ?

Still doesn't answer the rather more important question - why not just
stick a NULL on the end instead of all the nutty hacks ?
