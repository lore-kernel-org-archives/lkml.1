Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbZDQCj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbZDQCj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZDQCjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:39:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:41162 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbZDQCju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:39:50 -0400
Date: Thu, 16 Apr 2009 22:39:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/3] AHCI updates: Marvell AHCI PATA works; pata_marvell fate?
Message-ID: <20090417023949.GA14469@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This is an update of the recent libahci patchset, currently available
on the 'libahci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

These patches move a large amount of code from the currently
self-contained ahci driver to a new kernel module, libahci,
in preparation for supporting some "98% AHCI clones" from Marvell and
ACard.

This also has the nice side effect of isolating the generic AHCI
controller code from the grungy vendor-specific details, and opens the
way for supporting AHCI on non-PCI buses (at least one such example
exists, amba).

Changes since last posting:  Marvell PATA started working

Marvell 6145 has successfully been stress-tested with the following
modern, high performance 2GB hard drive:

    ATA device, with non-removable media
	Model Number:       WDC AC22100H                            
	Firmware Revision:  10.07H12
    Standards:
	Likely used: 2

Marvell PATA on 6121 and similar chips should also work, but that hasn't
yet been tested.  Here's the full list of what still needs testing:

- master + slave devices
- ATAPI
- 6121 (6123? others?)

Also, there is the open question of how to deal with pata_marvell
co-existence (hello, Alan :)), now that we have two noticeable driver
changes in this area:
	- Marvell AHCI-alikes moved from 'ahci' to 'mv-ahci'
	- We can now fully support SATA+PATA configurations
	  in 'mv-ahci'

The mv-ahci code is obviously still a bit raw with "#if 0" in places,
but it is nonetheless ready for testing.



