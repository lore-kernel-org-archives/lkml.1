Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYBES4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYBES4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYBES4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:56:30 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38981 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbYBES43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:56:29 -0500
Date: Tue, 5 Feb 2008 13:56:28 -0500
To: Marc Donner <donner@dbd-breitband.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dma error on boot with cf card
Message-ID: <20080205185628.GF26259@csclub.uwaterloo.ca>
References: <200802051852.29592.donner@dbd-breitband.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802051852.29592.donner@dbd-breitband.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 06:52:29PM +0100, Marc Donner wrote:
> hi,
> 
> i have a problem using a cf card with an ide adapter. 
> using debian kernel 2.6.18-5 
> 
> on boot:
> Feb  5 17:38:06 kernel: hdd: max request size: 128KiB
> Feb  5 17:38:06 kernel: hdd: 2000880 sectors (1024 MB) w/2KiB Cache, 
> CHS=1985/16/63, UDMA(33)
> Feb  5 17:38:06 kernel:  hdd:<4>hdd: dma_timer_expiry: dma status == 0x41
> Feb  5 17:38:06 kernel: hdd: DMA timeout error
> Feb  5 17:38:06 kernel: hdd: dma timeout error: status=0x58 { DriveReady 
> SeekComplete DataRequest }
> Feb  5 17:38:06 kernel: ide: failed opcode was: unknown
> Feb  5 17:38:06 kernel: hdd: irq timeout: status=0xd0 { Busy }
> Feb  5 17:38:06 kernel: ide: failed opcode was: unknown
> Feb  5 17:38:06 kernel: ide1: reset timed-out, status=0xff
> Feb  5 17:38:06 kernel: hdd: status timeout: status=0xff { Busy }
> Feb  5 17:38:06 kernel: ide: failed opcode was: unknown
> Feb  5 17:38:06 kernel: hdd: drive not ready for command
> Feb  5 17:38:06 kernel: ide1: reset timed-out, status=0xff
> Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 0
> Feb  5 17:38:06 kernel: Buffer I/O error on device hdd, logical block 0
> Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 0
> Feb  5 17:38:06 kernel: Buffer I/O error on device hdd, logical block 0
> Feb  5 17:38:06 kernel:  unable to read partition table
> Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 2000640
> Feb  5 17:38:06 kernel: Buffer I/O error on device hdd, logical block 250080
> Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 2000640

Adapter doesn't support DMA, but controller and CF cards do.  To fix,
tell the system NOT to use dma on that interface.

Most IDE to CF adapters fail to connect the DMA pins correctly since it
was a fairly (3 or 4 years ago) revision to the CF spec to support DMA
at all.

--
Len Sorensen
