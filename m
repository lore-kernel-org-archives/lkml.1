Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXIWPlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXIWPlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 11:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXIWPkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 11:40:51 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:21750 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbXIWPku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nb9ifN7e9/68Qk16NP77hlXCei+SlPm2NQGHFvNRx2hNHzwjo3M54Jnm+YSAWFklTi9KxhDQUv4Rv19JyoVrctiipGLJF4CPBiDnyglBY5KaHibbTYKdYxGZePLrgIuzYnPI1niVAxgXXRuCVVTYmisbw5r4b28Tre7vDdBZIVY=
Message-ID: <64bb37e0709230840o599a4e39l18f85d4791c36d42@mail.gmail.com>
Date: Sun, 23 Sep 2007 17:40:44 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Cc: "Jens Axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <20070923151105.5d491df4@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070921085711.GG2367@kernel.dk>
	 <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
	 <20070923151105.5d491df4@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Sep 18 18:50:01 treogen [   63.440000] ata1.00: status: {DRDY }
> > Sep 18 18:50:01 treogen [   63.440000] ata1: hard resetting link
>
> Timed out waiting for data transfers to complete that didn't. Does sound
> like the device got told the wrong sized transfer.
>
>
> It then falls off the bus because Jeff hasn't merged Mark Lord's DRQ
> draining patch.

One time the error was different:
Sep 11 19:19:24 treogen [   33.340000] ata1.00: exception Emask 0x20
SAct 0x1 SErr 0x0 action 0x2
Sep 11 19:19:24 treogen [   33.340000] ata1.00: irq_stat 0x00020002,
PCI master abort while fetching SGT
Sep 11 19:19:24 treogen [   33.340000] ata1.00: cmd
61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
Sep 11 19:19:24 treogen [   33.340000]          res
50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
Sep 11 19:19:24 treogen [   33.340000] ata1.00: status: {DRDY }
Sep 11 19:19:24 treogen [   33.670000] ata1: soft resetting link
Sep 11 19:19:24 treogen [   33.710000] ata1: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Sep 11 19:19:24 treogen [   33.800000] ata1.00: configured for UDMA/100
Sep 11 19:19:24 treogen [   33.800000] ata1: EH complete

This was repeated 12 times.
(Diff between a good boot and one with that error is here:
http://lkml.org/lkml/2007/9/14/107 )

Torsten
