Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYCZRIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYCZRIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYCZRI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:27 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29079 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYCZRI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:26 -0400
Message-Id: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:10:58 -0600
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
Subject: [patch 00/37] PNP resource_table cleanups
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

Bjorn
-- 
