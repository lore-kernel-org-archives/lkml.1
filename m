Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYGKUcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYGKUcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYGKUbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:31:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35556 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbYGKUbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:31:52 -0400
Date: Fri, 11 Jul 2008 21:14:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080711211409.2eef4ddb@lxorguk.ukuu.org.uk>
In-Reply-To: <200807112043.36772.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
	<20080706230118.GA25905@devserv.devel.redhat.com>
	<200807102235.22651.linux@rainbow-software.org>
	<200807112043.36772.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > commenting out the error check after ata_dev_init_params() call in
> > ata_dev_read_id() function (libata-core.c), I got at least the device name.
> > The capacity is 0 so it doesn't work, obviously:

If you don't read the ID then it wouldn't.

> I captured the IDENTIFY data from the virtual device. I'm not ATA guru but
> looking at the data, there are zeros at many places where something should be.
> That number starting at 0x78 looks like size of the array in sectors
> (0x4C726C or 0x4C6C72 - the array is built from 2.5GB and 6.4GB drives).

The Ident data for the virtual device is fairly sparse but the specs
don't require a lot of the field are filled in and only the LBA really
matters.

