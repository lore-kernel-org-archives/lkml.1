Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXFTQ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXFTQ44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXFTQ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:56:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36322 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbXFTQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:56:45 -0400
Date: Wed, 20 Jun 2007 18:01:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stuart_Hayes@dell.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070620180123.642316ae@the-village.bc.nu>
In-Reply-To: <20070620162845.GY5836@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com>
	<4677FFF1.2010308@ru.mvista.com>
	<20070619164854.GR5836@austin.ibm.com>
	<200706192043.40298.bzolnier@gmail.com>
	<46783777.10607@ru.mvista.com>
	<20070620162845.GY5836@austin.ibm.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Google seems to show that there is no publically available 
> firmware updates for Maxtor disks.

There are for some but only if you irritate the tech support people.

> hours at high cpu usage.... There were maybe a a dozen DriveReady
> SeekComplete Timeout errors clustered a few minutes apart.  

That suggests the drive is having problems occassionally and that the DMA
path code then blows up when they occur.

> Is there a way of viewing the contents of he command queue on
> the hard drive, to see if the command actually made it across?

queue ? You are overestimating IDE ;)

When the command is written you wait 400nS and then BSY is supposed to be
asserted. DRQ and other bits then handshake the data at the software
level with IORDY doing it at the hardware level for PIO (except in early
drives/low speeds where its done by the prayer and timing tolerance
approach)

Its unlikely the command got lost. The IRQ could have done but the error
path tries to spot that case by reading the status register - which
hangs. So in theory it could be a lost IRQ and if the reset works we'll
find that out.

Alan


