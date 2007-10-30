Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXJ3PdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXJ3PdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXJ3Pcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:32:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54037 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756505AbXJ3Pcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:32:53 -0400
Date: Tue, 30 Oct 2007 15:34:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071030153417.59b9182c@the-village.bc.nu>
In-Reply-To: <47274A5F.6070409@gentoo.org>
References: <47274A5F.6070409@gentoo.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 15:14:39 +0000
Daniel Drake <dsd@gentoo.org> wrote:

> Hi Alan,
> 
> In 2.6.23 and previous, CD writing works fine on my system. I'm using 
> ata_piix on:
> 
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA 
> IDE Controller (rev 01)
> 
> When I'm running CD writing utilities, I sometimes see this message in 
> the kernel logs:
> 	ata2.00: 66 bytes trailing data
> Things do work fine though.

By luck in part I suspect. That shouldn't be happening and indicates
something is very wrong. With the fifo buffers set right that may well
get worse.

> git bisect lead me to commit 2db78dd302d26d242d3e8e5c4c5024b6c3ea93c2 as 
> the culprit.
> 
> Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date:   Tue Oct 2 13:53:04 2007 -0700
> 
>      libata_scsi: Fix ATAPI transfer lengths
> 
>      Some controller variants snoop the ATAPI length value for Packet
>      transfers to do state machine and FIFO management. Thus we want to
>      set it properly, even for cases where it is otherwise meaningless.
> 
> Any ideas?

Not immediately - but if you've got wrong transfer lengths its a
candidate for this.

Ok lets start with the basics

If you mount a CD and use it does it work
If you use cdrecord does it work ?

What vendor drive and does it seem to be a specific box/drive that
triggers this ?

Alan
