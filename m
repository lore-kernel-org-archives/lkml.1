Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYLRWk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYLRWk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYLRWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:40:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36062 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbYLRWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:40:18 -0500
Date: Thu, 18 Dec 2008 22:40:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O
 support properly
Message-ID: <20081218224010.45e3ce55@lxorguk.ukuu.org.uk>
In-Reply-To: <200812182142.16533.bzolnier@gmail.com>
References: <494A5BBF.8000807@inf.tu-dresden.de>
	<494A837A.50801@garzik.org>
	<494A8768.4080100@ru.mvista.com>
	<200812182142.16533.bzolnier@gmail.com>
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

> OTOH the current patch is safe even for 2.6.28 (based on years of experience
> with the check that we had in IDE subsystem) and will fix some libata drivers
> (pata_legacy, pata_qdi and pata_winbond) to use dword IO on >= ATA-2 devices.
> 
> [ In reality this a regression fix for IDE -> libata conversion as it is a
>   huge performance improvement for the above mentioned DMA-less drivers. ]

The 32bit PIO support is already queued up and went to Jeff a while ago
so thats all in hand - its btw a big win on some suprising chipset cases
including Intel ICH chipsets.

> Jeff, I would like to merge it through IDE tree since the other patch depends
> on it but if you want to go ahead and push it to Linus earlier feel free to
> do it (or I can include it into the next IDE fixes pull request if you like).

Its still broken. You cannot use the version check for versions below 3.
I remain unconvinced we should be looking at it anywhere except specific
pure ISA cycle pass through hardware and thus it belongs as a helper for
those drivers not as ata_has_mumble stuff as its not ATA - eide_* maybe.

Doubly complicating it is the small detail that ATA1 devices don't
all respond to IDENTIFY in the first place....

Alan
