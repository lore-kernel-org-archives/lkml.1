Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYFFKeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYFFKeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYFFKd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:33:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48162 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857AbYFFKd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:33:57 -0400
Date: Fri, 6 Jun 2008 11:18:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Anil kumar <anils_r@yahoo.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: blk_queue_hardsect_size 520-byte sector
Message-ID: <20080606111807.44d0be02@core>
In-Reply-To: <20080606075432.GH5757@kernel.dk>
References: <339116.28290.qm@web32404.mail.mud.yahoo.com>
	<20080606075432.GH5757@kernel.dk>
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

On Fri, 6 Jun 2008 09:54:33 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Jun 05 2008, Anil kumar wrote:
> > Hi,
> > 
> > Can I call blk_queue_hardsect_size in a driver and set it to 520-byte
> > as hardware sector size.  How does the kernel and block layers take
> > the request, will it be in multiples of 520-bytes aligned or 512 bytes
> > aligned?
> 
> No, Linux only supports power-of-2 hardware block sizes I'm afraid.

And only some of those - which is why we can't support CP/M disks and
also early smartmedia stuff (128/256 byte/sector)

If you are trying to deal with 520 byte blocks that are 512 bytes file
system data + 8 bytes of meta data then use 512 byte block sizes and put
the meta-data somewhere else or provide a different way to access it  -
eg ATA uses 512 byte sectors for normal ATA but the sg_io() ioctl path
allows the issuing of commands like READ_LONG for specific cases where
the additional meta data is needed.

Alan
