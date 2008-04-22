Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbYDVCBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbYDVCBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbYDVCB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:01:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49529 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbYDVCB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:01:29 -0400
Message-ID: <480D46F6.3080305@garzik.org>
Date: Mon, 21 Apr 2008 22:01:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cdrom: use kmalloced buffers instead of buffers on stack
References: <200804220100.m3M10sva024025@hera.kernel.org>
In-Reply-To: <200804220100.m3M10sva024025@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=22a9189fd073db3d03a4cf8b8c098aa207602de1
> Commit:     22a9189fd073db3d03a4cf8b8c098aa207602de1
> Parent:     0a0c4114df4a6903bccb65b06cabb6ddc968f877
> Author:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> AuthorDate: Wed Mar 26 12:09:38 2008 +0100
> Committer:  Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Mon Apr 21 09:50:08 2008 +0200
> 
>     cdrom: use kmalloced buffers instead of buffers on stack
>     
>     If cdrom commands are issued to a scsi drive in most cases the buffer will be
>     filled via dma.  This leads to bad stack corruption on non coherent platforms,
>     because the buffers are neither cache line aligned nor is the size a multiple
>     of the cache line size.  Using kmalloced buffers avoids this.
>     
>     Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/cdrom/cdrom.c |  274 ++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 181 insertions(+), 93 deletions(-)

Eh... AFAICS this is only really useful in two of the cases converted.

For all the other cases (<= 32 bytes), it is _far_ less complex, far 
less code to simply communicate the additional alignment requirements to 
the compiler.

What about __attribute__ __aligned__?  Was that tried?

	Jeff


