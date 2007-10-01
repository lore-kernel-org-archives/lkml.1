Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbXJAWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbXJAWAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXJAWAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:00:46 -0400
Received: from lixom.net ([66.141.50.11]:45833 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXJAWAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:00:45 -0400
Date: Mon, 1 Oct 2007 17:04:39 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-ide@vger.kernel.org, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: [regression] 2.6.23 sata_mv EH updates broke my 7042 controller
Message-ID: <20071001220439.GA15332@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just pulled out my Marvell 7042 SATA controller here to give it a spin
and noticed that it no longer worked (i.e. init segvs when loading from
it), etc. 2.6.22 is fine.

Bisecting (just the file drivers/ata/sata_mv.c) resulted in
bdd4dddee325a7dce3e84cf48201a06aa8508aa4 popping out as the culprit
(file version 4537deb5e90b717a725b3d74b58b4bb1d28443d0 is fine).

Just for sanity checking: Has anyone else used 7042/6042 with the current
mainline driver?

Hardware config in my case:
Highpoint 2310 controller
PPC (big endian)
WD Raptor disk

Works fine with the other controller I've been using (SIL24), and works
fine if I revert the driver.

It also works fine if I disable the IOMMU. This would point towards
either a stale dma mapping, or a missing setup of one.

Not being much at home in the SATA drivers I could keep digging but I
figured I'd bring it up first in case it rings a bell for someone.


-Olof
