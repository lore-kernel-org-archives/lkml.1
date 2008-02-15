Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYBOQBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYBOQBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYBOQBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:01:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46529 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753854AbYBOQBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:01:34 -0500
Date: Fri, 15 Feb 2008 15:53:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tim Ellis <tim@ngndg.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
Message-ID: <20080215155332.2b89c429@core>
In-Reply-To: <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	<1202850129.7410.22.camel@pasglop>
	<Pine.LNX.4.64.0802151651340.27735@axis700.grange>
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

> > That's strange though. Somebody with knowledge of that HW (or specs) who
> > can spot something ? Could it be an issue with timing ?
> > 
> > I don't have HW access to this machine. If somebody could send one to me
> > I could do more investigation.
> 
> Ben, would an ssh access to such a machine and to a terminal server 
> suffice?

It says clearly in the code where to start. See the FIXME notes in both
libata-sff and libata-core about MMIO. Neither the DMA transfer start or
the probe SRST sequence are correct with MMIO posting and this hasn't
been fixed as I pointed out was needed when I originally NAKked the
change.

Without those being fixed (especially SRST) on any device with heavy PCI
posting of mmio your controller *wont work*.

Alan
