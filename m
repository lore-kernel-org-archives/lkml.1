Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXCaXLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXCaXLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 19:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXCaXLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 19:11:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37716 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbXCaXLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 19:11:15 -0400
Date: Sun, 1 Apr 2007 01:14:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eduard Bloch <edi@gmx.de>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070401011452.7c0cbce9@the-village.bc.nu>
In-Reply-To: <20070331224021.GA6488@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net>
	<20070330111744.GA8889@rotes76.wohnheim.uni-kl.de>
	<20070330134327.GA24030@infradead.org>
	<20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
	<20070330191038.067c346b@the-village.bc.nu>
	<20070331170703.GA8179@rotes76.wohnheim.uni-kl.de>
	<20070331232002.7b478f37@the-village.bc.nu>
	<20070331224021.GA6488@rotes76.wohnheim.uni-kl.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The use of /dev/sg* is still common practice, its invention predates
> > 
> > The /dev/sg interface cannot do the locking. If you use /dev/sg you are
> 
> Again, it doesn't have to. It can pass the locking operations to the
> related block device driver.

No it can't. The driver has no idea what the locking rules are for
arbitary command blocks send to arbitary devices. /dev/sg is a *raw*
interface. You can send anything to anyone, and the locking rules for
that are far too complex for a giant morass of kernel code to get added.

The mess begins because you use /dev/sg and put it in a cdrom group
instead of using SG_IO on the /dev/sr device. The mess continues because
of the user of O_EXCL locking thus forcing re-open/close by HAL instead
of fcntl based co-operative locking.

The job of the kernel is not and never has been to anticipate and correct
everything stupid someone tries to do in user space. 

As I said before the people wanting to arbitrate serial ports got this
right in the mid 1970's your situation is not much more complicated,
unless you persist in using /dev/sg - which yes does make it hard, but so
does writing it in COBOL, or while standing on your head. And the
solution to all three cases is the same *DONT DO IT*

Alan
