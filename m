Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbXHFTle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbXHFTle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbXHFTl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:41:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53995 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbXHFTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:41:25 -0400
Date: Mon, 6 Aug 2007 20:48:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: =?UTF-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
Message-ID: <20070806204853.6a693c4b@the-village.bc.nu>
In-Reply-To: <46B773F6.7060603@gmx.net>
References: <200708031903.10063.jimis@gmx.net>
	<200708051903.12414.jimis@gmx.net>
	<46B60FB7.8030301@interia.pl>
	<200708052142.14630.jimis@gmx.net>
	<46B748DE.1060108@interia.pl>
	<46B773F6.7060603@gmx.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > In Your oprofile output I find "acpi_pm_read" particulary interesting. 
> > Unlike other VIA chipsets, which I know, Your doesn't use VLink to 
> > connect northbridge to southbridge. Instead PCI bus connects these two. 
> > As You probably know maximal PCI throughtput is 133MiB/s. In theory. In 
> > practice probably less.

acpi_pm_read is capable of disappearing into  SMM traps which will make
it look very slow.

> about 15MB/s for both disks. When reading I get about 30MB/s again from 
> both disks. The other disk, the small one, is mostly idle, except for 
> writing little bits and bytes now and then. Since the problem occurs 
> when writing, 15MB/s is just too little I think for the PCI bus.

Its about right for some of the older VIA chipsets but if you are seeing
speed loss then we need to know precisely which kernels the speed dropped
at. Could be there is an I/O scheduling issue your system shows up or
some kind of PCI bus contention when both disks are active at once.

> I have been ignoring these performance regressions because of no 
> stability problems until now. So could it be that I'm reaching the 
> 20MB/s driver limit and some requests take too long to be served?

Nope.

Alan
