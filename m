Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597Ab0ANUMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0ANUMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937Ab0ANUMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:12:51 -0500
Received: from khc.piap.pl ([195.187.100.11]:56868 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0ANUMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:12:50 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
References: <m33a4nfvva.fsf@intrepid.localdomain>
	<201001141659.19687.bzolnier@gmail.com>
	<20100114192210.62593ead@lxorguk.ukuu.org.uk>
Date: Thu, 14 Jan 2010 21:12:47 +0100
In-Reply-To: <20100114192210.62593ead@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Thu, 14 Jan 2010 19:22:10 +0000")
Message-ID: <m3my0gh2dc.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> I think this is the wrong place. If your platform can't do MMIO properly
> then the platform pci_iomap or pci quirk code should do the needed
> cleaning up, not put turds into the drivers. Why not just quirk it on your
> specific platform and clear the MMIO mapping.

We need to use the MMIO BAR at least for starting DMA transfers, the
I/O ones are 64KB-limited. We can't just use read[bw] if reading all
32 bits has side effects.

Most of the time there are no problems with MMIO on IXP4xx as modern
devices usually use 32-bit registers anyway, or at least they have no
problem with read[bw] always driving all four PCI byte enable lines
(write[bw] doesn't have this issue).
-- 
Krzysztof Halasa
