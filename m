Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYIVVGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYIVVGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYIVVGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:06:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39577 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855AbYIVVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:06:45 -0400
Date: Mon, 22 Sep 2008 16:06:44 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 0/4] x86: UV runtime bios calls
Message-ID: <20080922210644.GC222374@sgi.com>
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
	specific information.  The interface uses EFI SAL table entry.
	EFI provides a mechanism for defining function pointers to 
	firmware routines.  This patchset builds on the EFI mechanism
	to provide access to those firmware routines.

Patches:
	uv_efi_bios:	Look for SAL entry in EFI tables.

	uv_bios_common:	Add the EFI callback function using the EFI table
			entry.  Create associated wrapper code.  Initialize
			SAL system table entry info at boot time.

	uv_bios_call_partition: Add call to get partitioning related info.

	uv_sysfs:	Create sysfs entrys in /sys/firmware/sgi_uv/ for
			partitioning related information.

Implementation comments:

	This patch uses sal_systab.  sal_systab is used on ia64, but was
	not used on x86.  An alternative would be to create a new
	EFI entry type (uv_systab), though that would require adding 
	to struct efi.

	The location in sysfs (/sys/firmware/sgi_uv/) is based on
	community feedback.

	If EFI is not configured (CONFIG_EFI), the calls will return -ENOSYS.
	If run on a system with a bios that does not supportes EFI SAL, the
	calls will return -ENOSYS.

	Paul Jackson assisted in the development of this code.
	
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
