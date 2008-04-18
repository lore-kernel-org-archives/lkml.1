Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbYDRUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbYDRUvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbYDRUvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:51:35 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:16148 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbYDRUvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:51:33 -0400
Message-Id: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:49:55 -0600
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
Subject: [patch 00/53] PNP cleanup and convert to dynamic resources, v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This finally replaces the fixed-size pnp_resource_table
with something more dynamic so we can quit worrying about
table overflows.

Most of the patches here just lead up to the dynamic
resources patch by incrementally cleaning things up
and reducing the amount of code that knows about the
pnp_resource_table.

There are a *lot* of changes from v2, mostly to fix the
ISAPNP problem Rene pointed out (we need to track the
config register index so we write things back to the
same register we read them from).

Rene, you acked many of these patches previously, and
I noted those in the patches.  But where I made more than
trivial changes, I removed your ack.

Changes between v2 and v3:

  - several updates from Rene Herman's review:
	- tweak EISA ID conversion and keep high-order bit for ISAPNP
	- fix pnp_add_card_id() to bisection works better
	- fix some "x <= 0" tests when x is unsigned
	- make resource accessors inlines, not #defines
	- fix pnp_{port,mem,irq,dma}_valid() return int, not resource_size_t
	- fold isapnp_read_resources() back into isapnp_get_resources()
  - factored out pnp_init_resource() from pnp_{init,clean}_resource_table()
  - initialize generic pnp_dev fields earlier, to help dev_printk
  - add pnp_resource to hold ISAPNP register index
  - convert to resource management from table to list (finally)
  - remove pnp_dev->regs (only set by ISAPNP, never used)
  - in /sys/.../resources, don't sort resources by type

Changes between first post and v2:

  - export pnp_get_resource()
  - fix EISA ID conversion and make a common function for ISAPNP/PNPBIOS
  - fix typos in pnp_check_{port,mem,etc} that made resource assign fail

  - the following fixes should precede this series (they're in -mm already):
	- parport_pc: wrap PNP probe code in CONFIG_PNP
	- radio-cadet: wrap PNP probe code in CONFIG_PNP
	- smsc-ircc2: wrap PNP probe code in CONFIG_PNP
	- nsc-ircc: wrap PNP probe code in CONFIG_PNP

Bjorn

-- 
