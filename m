Return-Path: <linux-kernel-owner+w=401wt.eu-S1761083AbXJYG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761083AbXJYG5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbXJYG5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:57:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:16544 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756265AbXJYG5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:57:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,328,1188802800"; 
   d="scan'208";a="305133545"
Subject: [PATCH 0/3 -v4] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Oct 2007 14:57:40 +0800
Message-Id: <1193295460.23935.201.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Oct 2007 06:54:52.0914 (UTC) FILETIME=[F1B4FD20:01C816D3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following sets of patches add EFI/UEFI (Unified Extensible Firmware
Interface) runtime services support to x86_64 architecture. The
patches have been tested against 2.6.24-rc1 kernel on Intel platforms
with EFI1.10 and UEFI2.0 firmware.


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
