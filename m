Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYJOULR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYJOULR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYJOULB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:11:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43165 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507AbYJOULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:11:00 -0400
Date: Wed, 15 Oct 2008 15:10:58 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 0/7] x86: UV runtime bios calls
Message-ID: <20081015201058.GA197213@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 0/7] x86: UV runtime bios calls

Resubmit four patches (per Ingo's request) with three additional patches.

Purpose: 
	Create an interface to allow calls into bios to return platform
	specific information.  The interface adds a new EFI table entry
	for UV.  EFI provides a mechanism for defining function pointers
	to firmware routines.  This patchset builds on the EFI mechanism
	to provide access to those firmware routines for UV.

Patches:
	[1/7] uv_efi_bios:	Look for UV entry in EFI tables.

	[2/7] uv_bios_common:	Add the EFI callback function using the EFI
			table entry.  Create associated wrapper code.
			Initialize UV system table entry info at boot time.

	[3/7] uv_bios_call_partition: Add call to get partitioning related info.

	[4/7] uv_sysfs:	Create sysfs entrys in /sys/firmware/sgi_uv/ for
			partitioning related information.

	[5/7] uv_bios_call_watchlist:	 Access UV watchlists.
	[6/7] uv_bios_call_memprotect: Modify UV memory protection.
	[7/7] uv_bios_call_reserve_page: Access UV reserve page.

Implementation comments:

	This patch adds a new EFI entry type (uv_systab).

	The location in sysfs (/sys/firmware/sgi_uv/) is based on
	community feedback.  The interface is documented in
	Documentation/ABI/testing/sysfs-firmware-sgi_uv.

	If EFI is not configured (CONFIG_EFI), the calls will return -ENOSYS.
	If run on a system with a bios that does not support EFI UV, the
	calls will return -ENOSYS.

	Paul Jackson assisted in the development of this code.
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
