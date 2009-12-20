Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZLTAj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZLTAj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 19:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZLTAj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 19:39:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39996 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754565AbZLTAj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 19:39:26 -0500
Date: Sun, 20 Dec 2009 00:41:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: pata_cmd64x broken in 2.6.33-rc1 on sparc64
Message-ID: <20091220004115.0529a438@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.SOC.1.00.0912200017540.17801@math.ut.ee>
References: <alpine.SOC.1.00.0912200017540.17801@math.ut.ee>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60

The sanity check that fails here is bus master DMA stop called but either
no DMA is running or the DMA is down as a different device.

> ata2.00: ATAPI: CRD-8322B, 1.06, max MWDMA2
> pata_cmd64x: active 3 recovery 1 setup 1.
> pata_cmd64x: active 3 recovery 1 setup 1.
>  sda:
> 
> 
> and hangs here.

First real DMA command - probably waiting for a DMA to complete that
doesn't exist from the above error.


Jeff - just drop the cmd64x diff for now
