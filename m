Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYIZUBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYIZUBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYIZUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:01:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35153 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbYIZUBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:01:33 -0400
Date: Fri, 26 Sep 2008 15:01:32 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: [PATCH 0/4] x86: UV runtime bios calls v2
Message-ID: <20080926200132.GA138671@sgi.com>
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
	specific information.  The interface adds a new EFI table entry
	for UV.  EFI provides a mechanism for defining function pointers 
	to firmware routines.  This patchset builds on the EFI mechanism
	to provide access to those firmware routines.

Version 2 changes:
	Add uv_systab to efi struct.
	Define efi_call* stubs in include/asm-x86/uv/bios.h.
	Made symbols EXPORT_SYMBOL_GPL().
	Added check for failure on sysfs_create_file() calls.
	Other code style changes.

Patches:
	uv_efi_bios:	Look for UV entry in EFI tables.

	uv_bios_common:	Add the EFI callback function using the EFI table
			entry.  Create associated wrapper code.  Initialize
			UV system table entry info at boot time.

	uv_bios_call_partition: Add call to get partitioning related info.

	uv_sysfs:	Create sysfs entrys in /sys/firmware/sgi_uv/ for
			partitioning related information.

Implementation comments:

	This patch adds a new EFI entry type (uv_systab).

	The location in sysfs (/sys/firmware/sgi_uv/) is based on
	community feedback.  The interface is documented in
	Documentation/ABI/testing/sysfs-firmware-sgi_uv.

	If EFI is not configured (CONFIG_EFI), the calls will return -ENOSYS.
	If run on a system with a bios that does not supportes EFI UV, the
	calls will return -ENOSYS.

	Paul Jackson assisted in the development of this code.
	
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
