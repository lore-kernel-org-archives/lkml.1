Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYBQWkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYBQWkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYBQWkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:40:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49769 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753972AbYBQWkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:40:02 -0500
Date: Sun, 17 Feb 2008 22:31:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] libata: implement 32-bit transfers for PIO mode
Message-ID: <20080217223134.1c61809b@core>
In-Reply-To: <20080217211810.GA15001@1wt.eu>
References: <20080217211810.GA15001@1wt.eu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thus, I have implemented the 32-bit mode to bring the performance back
> to the level of the old IDE driver. I jumped from 1.5 MB/s to 2.5 MB/s,
> which is an important difference at this level of performance, especially
> when large files are read. The 32-bit mode is enabled using the ioctl
> which is already implemented but only accepts a null value.

Excellent, that has been on my TODO list for some time and I'd only
gotten as far as putting into the ISA/VLB drivers rather than generally
testing.

I'm not however sure this should be a DFLAG but should be an alernative
ata_data_xfer method - I say that because VLB needs to wrap it and some
controllers have quirky rules for 32bit xfers. (Also some small number of
pre ATA disks can't handle the different timing cycles from a 32bit ISA
I/O being redirected their way).

Alan
