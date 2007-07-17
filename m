Return-Path: <linux-kernel-owner+w=401wt.eu-S935991AbXGQUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935991AbXGQUjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXGQUi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:38:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39975 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXGQUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:38:58 -0400
Date: Tue, 17 Jul 2007 21:38:53 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Dike <jdike@addtoit.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, jdike@karaya.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: uninline check_signature()
Message-ID: <20070717203853.GO21668@ftp.linux.org.uk>
References: <200707161802.l6GI2tNp007390@hera.kernel.org> <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org> <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org> <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin> <20070717163328.GG7965@c2.user-mode-linux.org> <Pine.LNX.4.64.0707171842590.10600@anakin> <alpine.LFD.0.999.0707171102040.19166@woody.linux-foundation.org> <Pine.LNX.4.64.0707172225260.23024@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707172225260.23024@anakin>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:31:08PM +0200, Geert Uytterhoeven wrote:
> And we'll all live with a check_signature() in our kernel, which is used
> only by a few legacy drivers that depend on ISA || PCI...
> 
> OR I'll have to disable HAS_IOMEM on m68k, and invent a new Kconfig
> symbol for lots of other stuff that currently depends on HAS_IOMEM...

Actually...  Is there any reason why it's not simply
	kmalloc
	memcpy_fromio
	memcmp
on all targets?  Or just a variably-sized auto array, since we never
do it for large stuff, IIRC...
