Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXJMMA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXJMMA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXJMMAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:00:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50820 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753314AbXJMMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:00:14 -0400
Date: Sat, 13 Oct 2007 13:02:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [linux-2.6.git] IDE/ATA fighting over driver name?
Message-ID: <20071013130219.1f020d49@the-village.bc.nu>
In-Reply-To: <4710A31A.7020204@garzik.org>
References: <1192254081.29452.13.camel@Homer.simpson.net>
	<4710A31A.7020204@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 06:51:06 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Mike Galbraith wrote:
> > Greetings,
> > 
> > Perhaps my .config is dainbramaged.  When make oldconfig asked me if I
> > wanted CONFIG_PATA_PLATFORM, I said "Damned if I know, go for it".
> > 
> > drivers/ide/legacy/ide_platform.c:		.name = "pata_platform",
> > drivers/ata/pata_platform.c:#define DRV_NAME "pata_platform"
> 
> That's a clear bug..  IDE's should be called ide_platform.

No its intentional and was discussed. Both of them provide an identical
platform driver interface, so they both use the same name. This means an
embedded platform developer doesn't have to choose which driver each of
their downstream users gets.

Probably just needs a bit of ifdef twiddling, if its even a bug (which is
not clear).

Alan
