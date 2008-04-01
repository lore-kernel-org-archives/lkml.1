Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYDAPSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYDAPSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbYDAPRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:17:40 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:4290 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbYDAPRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:17:39 -0400
Message-Id: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:34 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 00/37] PNP resource_table cleanups, v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches does some PNP housecleaning and
consolidation.

PNP currently uses a fixed-size table (pnp_resource_table)
to track the IO, MMIO, IRQ, and DMA resources used by a
device.  Some motherboard devices have many resources, so
we've been plagued by table overflows and we've had to
drastically increase the table size, which wastes a lot
of memory.

The end goal is to replace that fixed-size table with something
more dynamic.  These patches don't go that far, but they do make
pnp_resource_table private to the PNP core and centralize all
references to it in a small set of shared functions.

In addition, this series contains a number of related
cleanups, like centralized allocation of struct pnp_dev,
conversion to dev_printk when possible, removing many
PNP core internal functions from the public interface,
and alignment of the ISAPNP, PNPBIOS, and PNPACPI backends.

Changes between first post and v2:

  - export pnp_get_resource()
  - fix EISA ID conversion and make a common function for ISAPNP/PNPBIOS
  - fix typos in pnp_check_{port,mem,etc} that made resource assign fail

  - the following fixes should precede this series (they're in -mm already):
	- parport_pc: wrap PNP probe code in CONFIG_PNP
	- radio-cadet: wrap PNP probe code in CONFIG_PNP
	- smsc-ircc2: wrap PNP probe code in CONFIG_PNP
	- nsc-ircc: wrap PNP probe code in CONFIG_PNP

Thanks to Rene Herman for finding and fixing the EISA ID and resource
check bugs.

Bjorn
-- 
