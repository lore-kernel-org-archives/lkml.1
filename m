Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYKYADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYKYADT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYKYADJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:03:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51010 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752066AbYKYADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:03:08 -0500
Date: Tue, 25 Nov 2008 00:03:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: petkovbb@gmail.com, sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081125000306.014f7771@lxorguk.ukuu.org.uk>
In-Reply-To: <20081124230948.GB8293@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie>
	<20081124184321.GA8293@csn.ul.ie>
	<20081124185453.57ca7dcc@lxorguk.ukuu.org.uk>
	<20081124230948.GB8293@csn.ul.ie>
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

> Then can the message outputted printed out say something along those
> lines? On this particular machine, probing 0x3F resulted in a misconfigured

That is exactly what it says at the moment.

> machine. It's not obvious to me at all that 0x3F means probe everything,
> possibly with adverse results and 0x03 means peer at primary/secondary.

> Which in this case resulted in no disk because the mask defaults to 0
> now instead of 0x3 or anything else.

The mask is set to 0 and then the master/slave are detected based upon
the presence of PCI IDE devices on the master/slave ports.

> What you suggest for the numbers in each case is right, but it's not
> obvious. The machine might be so old that no will encounter this problem
> in practice.

That is why pata_legacy does it automatically. Users shouldn't need to.

> > If you want it to just work automatically use pata_legacy instead as that
> > automatically flips between probing ISA tertiary devices and leaving
> > things well alone according to the presence of PCI bus.
> > 
> 
> It doesn't find the disk.

If pata_legacy fails to find the disk then please send me an lspci
-vvxxx, chances are you shouldn't be using pata_legacy or ide_generic in
the first place but have a PCI device and don't have the right driver
loaded (or we don't have a right driver in which case it needs the
heuristics fixing up)
