Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYGCVgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYGCVgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYGCVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:36:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48200 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753409AbYGCVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:36:33 -0400
Message-Id: <20080703213348.489120321@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 16:33:48 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 00/13] GRU Driver V3 -  Overview
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds a driver for the SGI UV GRU. The driver is still
in development but it currently compiles for both x86_64 & IA64. All simple
regression tests pass on IA64. Although features remain to be added, I'd like to
start the process of getting the driver into the kernel. Additional kernel
drivers will depend on services provide by the GRU driver.

The GRU is a hardware resource located in the system chipset. The GRU
contains memory that is mmaped into the user address space. This memory is
used to communicate with the GRU to perform functions such as load/store,
scatter/gather, bcopy, AMOs, etc.  The GRU is directly accessed by user
instructions using user virtual addresses. GRU instructions (ex., bcopy) use
user virtual addresses for operands.

The GRU contains a large TLB that is functionally very similar to processor TLBs.
Because the external contains a TLB with user virtual address, it requires
callouts from the core VM system when certain types of changes are made to
the process page tables. There are several MMUOPS patches currently being
discussed but none has been accepted into the kernel. The GRU driver
is built using version V18 from Andrea Arcangeli.

Changes from V1 -> V2

	- lots of macro cleanup in gru_headers.h
	- coverted numerous macros to inline functions
	- deleted all (most) macros & functions that were used only
	  on the system simulator.
	- removed open coded ROUND_UP()
	- added missing EXPORTS
	- changed "address" parameteres to GRU kernel instructions
	  from void* to unsigned long. The values are physical addresses
	  (virtual is used only in user mode)
	- added GRU_DEBUG config option to enable GRU debug code.

Changes from V2 -> V3
	- verified again 2.6.26-rc8-mm1 with mmuops patch
	- A few trivial cleanups (spelling, etc)
	- Fixed __ia64__  -> CONFIG_IA64, etc.
	- Hugepages not supported yet. Fault will be return to user
	  if hugepage is referenced by GRU.


Open Issues:
	- use of /proc vs. /sys for resource allocation statistics
	- inline macros for GRU kernel instructions
	- Need better algorithms to handle oversubscription of
	  GRU resources. Current algorithm is functional but
	  crude.

Areas of Special Concern - would like careful community review:
	- use of get_user_pages() & follow_page()



--- jack

