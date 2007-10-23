Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbXJWVmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbXJWVmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXJWVm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:42:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46850 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbXJWVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:42:28 -0400
Date: Tue, 23 Oct 2007 22:45:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix IDE host_flags regression.
Message-ID: <20071023224524.27d3acc0@the-village.bc.nu>
In-Reply-To: <200710232150.14284.bzolnier@gmail.com>
References: <20071022.020900.41634188.davem@davemloft.net>
	<200710232150.14284.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - IDE_HFLAG_ERROR_STOPS_FIFO (the error path of pdc202xx_{old,new}) 

I've been playing with this a bit in libata - it seems the pdc202xx is a
bit more complicated. An error doesn't stop the FIFO, a reset does.

The problem thus seems to be triggered ultimately by the fact we call the
timeout method before doing a FIFO drain in some cases, and also that old
IDE tries to use PIO to flush a DRQ when the failing taskfile is a DMA
operation not PIO..

Alan

