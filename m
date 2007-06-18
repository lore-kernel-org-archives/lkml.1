Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbXFRUWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbXFRUWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760773AbXFRUVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:21:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35374 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754263AbXFRUVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:21:54 -0400
Date: Mon, 18 Jun 2007 21:27:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070618212704.394912b8@the-village.bc.nu>
In-Reply-To: <20070618175713.GD5836@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ide_dma_timeout_retry() in ide-io.c 
>   prints the "hdc: DMA Timeout error" then calls
>   HWIF(drive)->ide_dma_end(drive);
>     which returns, and then calls 
>   hwif->INB(IDE_STATUS_REG) which is needed as an argument to ide_error()
> 
> But this hangs! -- The INB never returns.
> Now:  hwif->INB = ide_inb; in ide-iops.c

Yep and the I/O cycle never completes so the box hangs. This occurs if
the drive blows up and never switches IORDY to indicate completion. The
hpt will also do this sometimes if it gets addled by a confused drive,
while an intel one often won't.

Alan
