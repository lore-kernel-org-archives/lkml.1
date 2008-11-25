Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYKYAaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYKYAaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYKYAaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:30:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37709 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752355AbYKYAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:30:00 -0500
Date: Tue, 25 Nov 2008 00:30:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: petkovbb@gmail.com, sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081125003002.5dcd9783@lxorguk.ukuu.org.uk>
In-Reply-To: <20081125001618.GD8293@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie>
	<20081124184321.GA8293@csn.ul.ie>
	<20081124185453.57ca7dcc@lxorguk.ukuu.org.uk>
	<20081124230948.GB8293@csn.ul.ie>
	<20081125000306.014f7771@lxorguk.ukuu.org.uk>
	<20081125001618.GD8293@csn.ul.ie>
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

> > The mask is set to 0 and then the master/slave are detected based upon
> > the presence of PCI IDE devices on the master/slave ports.
> > 
> 
> This detection was not happening but then again the proper driver was not
> compiled. The .config I used was very minimal and lacked most drivers.

The lspci shows the correct thing happened. You have PCI devices and
didn't load the right driver. No driver, no support, no suprise.

> It is certainly the case I was not using the correct driver. Using
> CONFIG_BLK_DEV_PIIX instead of CONFIG_IDE_GENERIC makes everything work as
> expected without having to pass special options.

It would do - and you don't want to use pata_legacy/ide-generic for PCI
devices. There are several with quirks, some even corruptors that the
legacy drivers do not know how to handle.

So I think this is a case of 'I put best steam coal in my car and it
didn't go'

Alan
