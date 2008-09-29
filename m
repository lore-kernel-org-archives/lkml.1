Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYI2WCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYI2WCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYI2WCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:02:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39896 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754097AbYI2WCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:02:06 -0400
Date: Mon, 29 Sep 2008 17:02:04 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 0/4] x86: UV runtime bios calls
Message-ID: <20080929220201.GB108640@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 0/4] x86: UV runtime bios calls

Purpose: 
	Create an interface to allow calls into bios to return platform
	specific information.  The interface adds a new EFI runtime call
	for OEMs.  EFI provides a mechanism for defining runtime calls 
	to firmware routines.  This patchset builds on the EFI mechanism
	to provide access to those firmware routines.

Version 3 changes:
	Add function (oem) to efi_runtime_services_t, replacing uv_systab.
	Use efi_call_virt<n>.
	Remove efi_call<n> stubs.


Version 2 changes:
	Add uv_systab to efi struct.
	Define efi_call* stubs in include/asm-x86/uv/bios.h.
	Made symbols EXPORT_SYMBOL_GPL().
	Added check for failure on sysfs_create_file() calls.
	Other code style changes.


Patches:
	uv_efi_bios:	Add function (oem) to efi_runtime_services_t.

	uv_bios_common:	Add the EFI callback function using the EFI oem
			runtime function.  Create associated wrapper code.

	uv_bios_call_partition: Add call to get partitioning related info.

	uv_sysfs:	Create sysfs entrys in /sys/firmware/sgi_uv/ for
			partitioning related information.

Implementation comments:

	This patch adds a new EFI runtime function (oem).

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
