Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYFQW7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYFQW7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYFQW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:59:33 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17549 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYFQW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:59:32 -0400
Message-Id: <20080617225823.045233728@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 17 Jun 2008 16:58:23 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 00/28] PNP: convert fixed tables to lists, v3
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains all my PNP patches that are not yet in Linus'
tree, including both the "convert resource table to dynamic list" series
and the "convert resource options to unified dynamic list" series.

This series should replace all the PNP patches in -mm from
    pnp-add-detail-to-debug-resource-dump.patch
    ...
    not-for-merging-pnp-changes-suspend-oops.patch
except for isa-set-24-bit-dma_mask-for-isa-devices.patch, which got
stuck in the middle but isn't really PNP-related.

I'll be on vacation for the rest of the week, so I won't be able to
respond to any issues until Monday.

Here are the significant changes since the last posting:

    - When replacing pnp_resource_table, the PNPACPI resource encoders
      have to explicitly handle disabled resources; previously any
      unused slots in the table were implicitly disabled.  This should
      fix Jiri Slaby's oops on suspend/resume (though he hasn't tested
      this version).
      
      This change is in the patch titled "PNP: replace pnp_resource_table
      with dynamically allocated resources".
      
    - Added a new patch to keep disabled IRQ and DMA resources when parsing
      current config.  This fixes a bug in the current (2.6.25) PNPACPI
      code: consider a device with (mem, irq0, irq1, io), where irq0 is
      disabled.  If we drop irq0 when parsing the _CRS, we will mistakenly
      put irq1 in the irq0 slot when we encode resources for an _SRS call.

    - Added a new patch to avoid interrupts used by an IDE controller in
      compatibility mode.  https://bugzilla.novell.com/show_bug.cgi?id=375836

    - Added a new PNPACPI patch to support HP vendor-specific descriptors.
      This has long been supported by arch/ia64/kernel/acpi-ext.c, which
      provides an hp_acpi_csr_space() interface, but I think it's better
      and more generic to support it in PNPACPI.

Changes since v2 of "convert resource options to unified dynamic list":

    - fixed bisection problem in quirk_ad1815_mpu_resources()
    - fixed checkpatch warning in pnp_show_options()
      (pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch)
    - replaced pnp_independent_option() with literal 0
    - fixed coding style in pnp/manager.c
    - added EXPORT_SYMBOL(pnp_possible_config)
      (pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch)

Bjorn
-- 
