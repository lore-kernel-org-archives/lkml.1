Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbYCPTMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbYCPTMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYCPTMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:12:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33813 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752169AbYCPTM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:12:29 -0400
Date: Sun, 16 Mar 2008 18:56:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080316185602.79064f7c@core>
In-Reply-To: <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
	<20080316140118.891732DC044@tippex.mynet.homeunix.org>
	<alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
	<200803161907.04581.bzolnier@gmail.com>
	<alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008 11:13:42 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 16 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> > 
> > We don't do error handling for special commands (REQ_TYPE_ATA_*) at all,
> > ide_error() just dumps device's status/error register(s) and finishes early:
> 
> Well that sounds bogus too, for all the same reasons already outlined. The 
> DRQ flag needs to be cleared up on error!

No it doesn't. DRQ simply means "drive has more data for the controller
if you want it". Interrupts are controlled via IEN and the interrupt line.

If the drive wants to give us data and we end the transaction that is
fine. In practice a tiny few devices crap themselves if we don't.

A few controllers require specific magic, either to ensure we never touch
data after an error, or that we drain enough bits to empty the internal
fifo the controller is using to improve ata performance and latches the
IRQ arrival against.

The PIIX/ICH is as it happens one of the most forgiving controllers
anyway. The later ICH (the ones that are also AHCI) are a bit fussier
about handling them to the spec because they seem to be some kind of
magic ICH emulation layer on an AHCI chip.

Alan



