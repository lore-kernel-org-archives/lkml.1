Return-Path: <linux-kernel-owner+w=401wt.eu-S937546AbXHIIVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937546AbXHIIVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760718AbXHIIUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:20:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:2028 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485AbXHIIU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:20:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,239,1183359600"; 
   d="scan'208";a="260855362"
Subject: [PATCH 0/2] x86_64 EFI boot support
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Aug 2007 16:20:30 +0800
Message-Id: <1186647630.15539.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 09 Aug 2007 08:20:17.0324 (UTC) FILETIME=[1E4926C0:01C7DA5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because supporting booting Linux kernel and supporting UEFI runtime
service on x86_64 UEFI platform are two separate steps. I decide to
push the booting support patches firstly, so that, the essential part
of UEFI64 support can go into mainstream kernel firstly.

---

Following sets of patches add EFI/UEFI (Unified Extensible Firmware
Interface) boot support to x86_64 architecture. The EFI runtime
service support is not added by the patches. The patches have been
tested against 2.6.23-rc2 kernel on Intel platforms with EFI1.10 and
UEFI2.0 firmware. With this set of patches applied, the 64bit and
32bit x86 kernel can be booted on x86_64 machine with UEFI64 firmware.

Because the EFI memory map is converted to E820 map in bootloader, now
the only needed code for booting Linux kernel on x86_64 UEFI platform
is the framebuffer driver.

UEFI specification can be found here: http://www.uefi.org

For booting the UEFI x86_64 enabled kernel, the machine with EFI/UEFI
firmware and the support of bootloader is required. Detailed usage
guide can be found in Documentation/x86_64/uefi.txt, which is added in
the patch: EFI boot document

Known issues:

- Boot protocol: because the real mode BIOS call can not be used in
  EFI platform, the standard boot protocol defined in
  Documentation/i386/boot.txt can not be used by EFI based
  bootloader. So, a internal boot protocol defined in
  Documentation/i386/zero-page.txt is used instead. Since this
  internal boot protocol is also used by many other bootloaders, such
  as kexec, LinuxBIOS and Gujin etc, maybe it is better to make this
  internal boot protocol become a public 32bit boot protocol for Linux
  kernel.

- Firmware information, such as ACPI root pointer, smbios pointer,
  etc. In orignal EFI supporting code, various firmware information is
  gotten through EFI configuration tables. But, I think the
  corresponding firmware support code need not depend on the EFI
  support. So, I think maybe it is a better idea to add these firmware
  information to 32bit boot protocol proposed previously, and they can
  be filled by bootloader if available.

Looking forward to your comments,

Best Regards,
Huang Ying
