Return-Path: <linux-kernel-owner+w=401wt.eu-S935884AbXGQUlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935884AbXGQUlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXGQUko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:40:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329AbXGQUkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:40:43 -0400
Date: Tue, 17 Jul 2007 13:40:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Jeff Dike <jdike@addtoit.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, jdike@karaya.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: uninline check_signature()
In-Reply-To: <Pine.LNX.4.64.0707172225260.23024@anakin>
Message-ID: <alpine.LFD.0.999.0707171338290.27353@woody.linux-foundation.org>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin>
 <20070717163328.GG7965@c2.user-mode-linux.org> <Pine.LNX.4.64.0707171842590.10600@anakin>
 <alpine.LFD.0.999.0707171102040.19166@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707172225260.23024@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Geert Uytterhoeven wrote:
> 
> OR I'll have to disable HAS_IOMEM on m68k, and invent a new Kconfig
> symbol for lots of other stuff that currently depends on HAS_IOMEM...

Well, as far as I'm concerned, you could also make all drivers that 
actually need "check_signature()" do a Kconfig level

	select CHECK_SIGNATURE

along with a

	config CHECK_SIGNATURE
		bool
		default n

in lib/Kconfig, and thus make it totally independent of any hw/bus 
features at all, and simply depend on whether it is needed or not. I'd be 
ok with that, and it's certainly "correct" too.

Hmm?

		Linus
