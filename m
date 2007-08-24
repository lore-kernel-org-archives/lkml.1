Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXHXU1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXHXU1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXHXU05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:26:57 -0400
Received: from [81.2.110.250] ([81.2.110.250]:60041 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570AbXHXU04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:26:56 -0400
Date: Fri, 24 Aug 2007 21:34:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, postfail@hushmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] /drivers/char sx.c ioremap -> pci_ioremap api
Message-ID: <20070824213439.0007e653@the-village.bc.nu>
In-Reply-To: <46CF399E.3010808@gmail.com>
References: <46CF2849.2090008@gmail.com>
	<4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com>
	<20070824201530.5d741b37@the-village.bc.nu>
	<46CF399E.3010808@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 22:03:42 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Alan Cox napsal(a):
> > ase, 0x80);
> >> remove also the hwbase var.
> >>
> >>> +	rebase = pci_iomap(pdev, 0, 0x80);
> >>>   	t = readl(rebase + CNTRL_REG_OFFSET);
> > 
> > Switch to ioread* if you are using the iomap interface. Its not a trivial
> 
> Why, if you know it's surely a mem region (and thus you rely on it and do
> ioremap)? There are many places in the kernel, where this approach is used, e.g.
> libata piix.

Every single one of them is wrong. The encoding of iomap values is
platform dependant. Fixed in my tree.
> 
> > conversion and its slower and bulkier - the original ioremap was much
> > better
> 
> at least get rid of the reading the hwbase address from pci conf space, use
> pci_resource_start instead.

Agreed entirely
