Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbYBOWgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbYBOWgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764895AbYBOWfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:35:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48364 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763489AbYBOWfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:35:32 -0500
Date: Fri, 15 Feb 2008 22:27:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Tim Ellis <tim@ngndg.com>,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
Message-ID: <20080215222725.0af29563@core>
In-Reply-To: <1203111956.22915.24.camel@pasglop>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	<1202850129.7410.22.camel@pasglop>
	<Pine.LNX.4.64.0802151651340.27735@axis700.grange>
	<20080215155332.2b89c429@core>
	<1203111956.22915.24.camel@pasglop>
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

> The dbdma start is mostly harmless (things don't get posted for -that-
> long), though I suppose it's worth fixing. Would reading back dmactl do
> in that case or do you foresee any kind of side effect ? (Maybe only
> doing it for MMIO ?)

The dmactl read back should be just fine, or any other DMA register (eg
status).

> As for SRST, I'm not totally confident how safe it is to read back
> there while doing the reset sequence, so I'm tempted to really only
> do it for MMIO and use altstat rather than ctl/stat (the later tends
> to have side effects which we don't want here).

Agreed - we know some controllers crap themselves spectacularly on
anything which causes a SATA data transfer to be needed during a reset so
the status is probably safest. The fact its not fixed is because nobody
has sat down to figure out what is safe.

> The main problem from here is that I don't know whether we are using
> MMIO or PIO from libata-core. Maybe I can add a host flag indicate
> that such flushing is needed ?

Easier to add that to the ioxxxx ops I suspect (ioispio/ioismmio say) ?

Alan
