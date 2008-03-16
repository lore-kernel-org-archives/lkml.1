Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbYCPTBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbYCPTBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYCPTA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:00:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54156 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752167AbYCPTA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:00:57 -0400
Date: Sun, 16 Mar 2008 18:44:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080316184459.098e18b6@core>
In-Reply-To: <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
	<200803101336.56159.bzolnier@gmail.com>
	<200803101410.27877.rjw@sisk.pl>
	<200803101504.17219.bzolnier@gmail.com>
	<20080316140118.891732DC044@tippex.mynet.homeunix.org>
	<alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
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

O> @@ -462,8 +462,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
>  		}
>  	}
>  
> -	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ &&
> -	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0)
> +	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ)
>  		try_to_flush_leftover_data(drive);

That is instant system death on some chipsets. The state machine on the
promise for example empties the FIFO and if you touch the data port again
before issuing a command you lock the PCI bus.

Alan
