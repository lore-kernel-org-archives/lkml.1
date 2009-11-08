Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZKHVHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZKHVHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZKHVHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:07:39 -0500
Received: from khc.piap.pl ([195.187.100.11]:49890 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbZKHVHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:07:38 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: IXP4xx repetitive 16-bit/32-bit I/O macros/inlines.
References: <m3iqdkc0n6.fsf@intrepid.localdomain>
	<4AF72907.1060705@hiramoto.org>
Date: Sun, 08 Nov 2009 22:07:41 +0100
In-Reply-To: <4AF72907.1060705@hiramoto.org> (Karl Hiramoto's message of "Sun,
	08 Nov 2009 21:24:39 +0100")
Message-ID: <m3pr7safoi.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Hiramoto <karl@hiramoto.org> writes:

>> Anybody using 32-bit PATA/SATA transfers on IXP4xx? :-)

> Yes, on  HPT371 IDE chip on the PCI  bus to interface to compact flash
> to store logs.

$ grep inherits drivers/ata/pata_hpt37x.c
        .inherits       = &ata_bmdma_port_ops,
        .inherits       = &hpt370_port_ops,
        .inherits       = &ata_bmdma_port_ops,
        .inherits       = &hpt372_port_ops,

Looks like 16-bit port_ops.

> For what it's worth I've only ever been able to make
> PIO work, I've never had any luck with the IDE DMA modes.  It hasn't
> been a high enough priority to investigate further.

Interesting. I have no issues with DMA modes, with VIA VT6421A (this
chip seems to have other critical problems), with CS5536 (PATA) and with
SIL3512 (the patch has to be applied in big-endian mode, and another
patch to sata_sil.c must be applied because IXP4xx can't do 8/16-bit
PCI MMIO read).
-- 
Krzysztof Halasa
