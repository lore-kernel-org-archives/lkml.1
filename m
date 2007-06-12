Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbXFLQA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbXFLQA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXFLQAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:00:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38614 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755401AbXFLQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:00:12 -0400
Date: Tue, 12 Jun 2007 17:05:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: libata passthru: support PIO multi commands
Message-ID: <20070612170519.5f427a70@the-village.bc.nu>
In-Reply-To: <466EB937.6050807@garzik.org>
References: <200706112200.l5BM0qFn005767@hera.kernel.org>
	<20070611233917.4bd8c6d7@the-village.bc.nu>
	<466DE438.70108@garzik.org>
	<20070612111621.10074408@the-village.bc.nu>
	<466EB937.6050807@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ata_scsi_pass_thru() is not executed at ioctl submission time (block 
> queue submission time), but rather immediately before it is issued to 
> the drive.  At that point you know the bus is idle, all other commands 
> have finished executing, and dev->multi_count is fresh not stale.  The 
> code path goes from ata_scsi_pass_thru() to ata_qc_issue() without 
> releasing the spinlock, even.

Think up to user space

Poorusersapp			set multicount to 4

Evilproprietarytuningdaemon	set multicount to 8

Poorusersapp			issue I/O

at which point an error is indeed best.

> But the last point is true -- we should error rather than just warn 
> there, AFAICS.

Definitely. We've been asked "please do something stupid" and not even in
a case where the requester may know better.

Alan
