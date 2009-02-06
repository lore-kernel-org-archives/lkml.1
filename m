Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZBFUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZBFUny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZBFUnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:43:46 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:50743 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZBFUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:43:46 -0500
Date: Fri, 6 Feb 2009 21:43:44 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jens Axboe <axboe@kernel.dk>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/02] 32-bit PIO wrappers for scatterlists
Message-ID: <20090206204343.GA13217@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While writing a driver for CB710 MMC host I had to implement PIO routines
that transferred data to/from buffers described by scatterlists. As it
turned later this scheme is needed for similar devices that can't handle
[scatter-gather] DMA in hardware.

Following is my implementation of such routines that should be generic
enough to use in drivers doing PIO by 32-bit accesses (PCI based devices
or maybe other 32-bit word based busses).

Current implementation has some limitations:
1. it advances scatterlist iterator always by multiple of 4 bytes
2. it silently inserts zeroes after last byte of buffer when transferring
   data to the device (that's actually a good thing for my driver)
3. it silently ignores data that does not fit into specified buffer when
   transferring data from the device (this also is a good thing for the
   driver I wrote)

What those points mean is that driver writer has to know how many bytes
there are available in the buffer if its important, and has to use
multiple-of-4 transfer sizes when doing more than one transfer using
a single iterator.

Patches are against vanilla kernel 2.6.28.

Best Regards,
Micha³ Miros³aw
