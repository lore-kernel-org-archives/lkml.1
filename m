Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXKZIUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXKZIUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXKZIUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:20:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:50722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbXKZIUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:20:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,466,1188802800"; 
   d="scan'208";a="279888704"
Subject: [PATCH -mm 0/4 -v6] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Nov 2007 16:23:37 +0800
Message-Id: <1196065417.14142.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Nov 2007 08:19:26.0764 (UTC) FILETIME=[0F2D0EC0:01C83005]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patchset adds EFI/UEFI (Unified Extensible Firmware
Interface) runtime services support to x86_64 architecture.

The patchset have been tested against 2.6.24-rc3-mm1 kernel on Intel
platforms with 64-bit EFI1.10 and UEFI2.0 firmware. Because the
duplicated code between efi_32.c and efi_64.c is removed, the patchset
is also tested on Intel platform with 32-bit EFI firmware.


v6:

- Fix a bug about runtime service memory mapping.

- Rebase on 2.6.24-rc3-mm1

v5:

- Remove the duplicated code between efi_32.c and efi_64.c.

- Rename lin2win<x> to efi_call<x>.

- Make EFI time runtime service default to off.

- Use different bootloader signature for EFI32 and EFI64, so that
  kernel can know whether underlaying EFI firmware is 64-bit or
  32-bit.

v4:

- EFI boot parameters are extended for 64-bit EFI in a 32-bit EFI
  compatible way.

- Add EFI runtime services document.

v3:

- Remove E820_RUNTIME_CODE, the EFI memory map is used to deal with
  EFI runtime code area.

- The method used to make EFI runtime code area executable is change:

  a. Before page allocation is usable, the PMD of direct mapping is
     changed temporarily before and after each EFI call.

  b. After page allocation is usable, change_page_attr_addr is used to
     change corresponding page attribute.

- Use fixmap to map EFI memory mapped IO memory area to make kexec
  workable.

- Add a kernel command line option "noefi" to make it possible to turn
  off EFI runtime services support.

- Function pointers are used for EFI time runtime service.

- EFI reboot runtime service is embedded into the framework of
  reboot_type.

- A kernel command line option "noefi_time" is added to make it
  possible to fall back to CMOS based implementation.

v2:

- The EFI callwrapper is re-implemented in assembler.


Best Regards,
Huang Ying
