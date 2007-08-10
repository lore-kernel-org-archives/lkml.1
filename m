Return-Path: <linux-kernel-owner+w=401wt.eu-S935963AbXHJMZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935963AbXHJMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbXHJMZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:25:50 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:43185 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbXHJMZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:25:49 -0400
Message-ID: <46BC58E8.50300@csr.com>
Date: Fri, 10 Aug 2007 13:24:08 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-list@drzeus.cx>
CC: David Vrabel <david.vrabel@csr.com>
Subject: [patch 0/5] sdio: various bug fixes and CSR specific support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2007 12:24:20.0732 (UTC) FILETIME=[60D9A3C0:01C7DB49]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This set of 5 patches fixes a few bugs in the SDIO support and adds
stuff required for CSR chips.

1. SHDC PCI cards produced by Arasan (for prototyping their SHDC IP)
report an invalid maximum block size.  These cards don't have a valid
vendor or device ID so we can't blacklist them.  Instead, just assume we
can always support a block size of 512 (which is the minimum possible).

2. Ensure we set the bus width the host uses if we set the card's bus
width to 4 bit mode.  Needless to say a host sending 1 bit mode data to
a card in 4 bit mode doesn't work.

3. Add defines for CSR specific CCCR vendor registers.

4. Add vendor and device IDs for CSR chips.

5. Add sdio_f0_readb() and sdio_f0_writeb() so drivers can read/write F0
registers.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
