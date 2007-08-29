Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbXH2N1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbXH2N1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbXH2N0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:26:54 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33426 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757275AbXH2N0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:26:53 -0400
Date: Wed, 29 Aug 2007 09:26:53 -0400
To: "Espen M. Rutger" <espen@rutger.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ide.c and compactFlash
Message-ID: <20070829132653.GA11130@csclub.uwaterloo.ca>
References: <46CD75F3.6030707@rutger.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CD75F3.6030707@rutger.no>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 01:56:35PM +0200, Espen M. Rutger wrote:
> I got problems with the IDE code which causes the kernel to freez after 
> printing out:
> 
> hda: status timeout: status=0xd0 { Busy }
> 
> kernel used: 2.4.18 crosscompiled with Montavista tools (ppc_82xx-gcc 
> (GCC) 3.2.1 20020930 (MontaVista))
> 
> The ide interface chip is a PD6729 configured to ATA mode.
> 
> CompactFlash cards: winsys 1GB industrial grade and simpleTech 1GB 
> industrial grade.
> 
> I beleive this is a timing issue and have tried to increase a udelay () 
> to 2 microseconds (instead of 1 microsecond) in the ide_wait_stat() 
> function - it took longer time to freez, but it still freezes...

Try booting with 'ide=nodma'.  Some compact flash cards support DMA
mode, and of course most IDE controllers support DMA mode, and if both
support it the kernel tends to try and enable it but if you don't have
the DMA lines connected it will fail and give annoying errors similar to
that one.  The DMA part of compact flash was a fairly recent addition
and the two affected lines used to be reserved on compact flash.  The
product I work on did not have the DMA lines on the previous board
design but we have it on the latest board revision.  On the old boards
we had to disable DMA support for IDE since otherwise certain types of
compact flash would have annoying timeouts trying to enable DMA.  On our
new board with the DMA lines, everything just works and the DMA access
gives about twice the read/write speed to the compact flash cards we are
using.

--
Len Sorensen
