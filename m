Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbXIIIG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbXIIIG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 04:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXIIIGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 04:06:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:60788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXIIIGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 04:06:21 -0400
Message-Id: <20070909080620.681518633@strauss.suse.de>
References: <20070909080620.009772613@strauss.suse.de>
User-Agent: quilt/0.46-57
Date: Sun, 09 Sep 2007 10:06:22 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/3] Express new ELF32 mechanisms in documentation
Content-Disposition: inline; filename=crashkernel-elf32
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reflects the
http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools-testing.git;a=commit;h=b9c3648e690ad0dad12389659673206213a09760
change in kexec-tools-testing also now in the kernel documentation.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 Documentation/kdump/kdump.txt |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -301,11 +301,13 @@ For ppc64:
 Notes on loading the dump-capture kernel:
 
 * By default, the ELF headers are stored in ELF64 format to support
-  systems with more than 4GB memory. The --elf32-core-headers option can
-  be used to force the generation of ELF32 headers. This is necessary
-  because GDB currently cannot open vmcore files with ELF64 headers on
-  32-bit systems. ELF32 headers can be used on non-PAE systems (that is,
-  less than 4GB of memory).
+  systems with more than 4GB memory. On i386, kexec automatically checks if
+  the physical RAM size exceeds the 4 GB limit and if not, uses ELF32.
+  So, on non-PAE systems, ELF32 is always used.
+
+  The --elf32-core-headers option can be used to force the generation of ELF32
+  headers. This is necessary because GDB currently cannot open vmcore files
+  with ELF64 headers on 32-bit systems.
 
 * The "irqpoll" boot parameter reduces driver initialization failures
   due to shared interrupts in the dump-capture kernel.

-- 
