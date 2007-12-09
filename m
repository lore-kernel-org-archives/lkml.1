Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXLINnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXLINnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXLINno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:43:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47091 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbXLINno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:43:44 -0500
Date: Sun, 9 Dec 2007 13:38:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071209133812.2d305a02@the-village.bc.nu>
In-Reply-To: <1197193794.6572.52.camel@pasglop>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	<1196899818.7033.11.camel@pasglop>
	<200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	<1196917447.7033.17.camel@pasglop>
	<200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	<1196922262.7033.33.camel@pasglop>
	<20071209021231.GA13729@linux-mips.org>
	<1197185091.6572.38.camel@pasglop>
	<1197193794.6572.52.camel@pasglop>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code now replaces the content of the resource structures with the
> hard-decoded legacy addresses for any IDE controller in legacy mode,
> just losing whatever was there (the real BAR value).

This is correct behaviour. It checks the port is in legacy mode. If the
port is in legacy mode the BAR value is undefined and in some cases
completely random.

> has, I don't know for sure), we have a quirk that puts those controller
> back into native mode. But so far, those quirks didn't change the
> resources as they were supposed to contain the proper BAR values that
> would, from then, be used.

Then your quirk is faulty (for the general case). The BAR values are
undefined at that point, they may not even be writable.

> I suspect any platform with such a quirk to turn IDE controllers into
> native mode will now -also- need to put back the BAR values in the
> struct resource, and do so -before- the platform fixup happens, that is
> from a header quirk.

Improbable unless its willing to rely on entirely undefined behaviour.

If you kick the device out of legacy mode (itself very very board
dependant) then you must find a suitable new resource allocation for the
controller. 

Alan
