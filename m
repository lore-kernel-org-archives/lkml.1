Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXDXPLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXDXPLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161810AbXDXPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:08:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:27388 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161797AbXDXPIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233076151:sNHT16413817"
Message-Id: <20070423163837.447443000@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 09:38:37 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com
Cc: asit.k.mallick@intel.com, suresh.b.siddha@intel.com
Cc: anil.s.keshavamurthy@intel.com, arjan@linux.intel.com
Cc: ashok.raj@intel.com, shaohua.li@intel.com
Subject: [Intel IOMMU][patch 0/8] Intel IOMMU Support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again!

Andrew: Could you help include in -mm to give it more exposure preparing for 
mainline inclusion with more testing?

This is a resend of the patches after addressing some feedback we received.

1. As len requested, we moved most of the acpi parts to drivers/pci instead
   of leaving them in drivers/acpi, including some renaming of functions,
   using just acpi_get_table() only.

2. Made the guard page support configurable.
3. Added new option to allocate consecutive address instead of re-using 
   free addresses as an experimental option, Not validated extensively.
   Its expected to improve in certain cases...
4. Fixed a couple minor bugs that got exposed in testing.


Some more interesting possibilities. -- enhancements to work on.

- In order to ensure we dont break any driver that may not be using dma api's
  here are some suggestions to work on.
    - Create a single 1-1 map, and make sure any pci device gets this map
      when they do a pci_set_master() to enable bus mastering automatically.
    - When the device driver does a first call to do a dma mapping, then
      dissociate the device from the unity map domain, to its own. This gives
      limited protection but doesnt break drivers that do not use dma 
      mapping.
    - Creating context entries only 1 per segment.. today we create one per 
      IOMMU which is not required.

This way we can avoid doing some of the workarounds we do for some devices
today, and will function as a default container for compatibility.

On one hand, this will provide more compatibility, but we will lose 
oppertunity to identify broken device drivers that dont use dma api's 
and fix them.... Depending on who you talk to.. some like it.. some just
hate it! and would like to fix the broken ones instead.

Cheers,
Ashok Raj
-- 
