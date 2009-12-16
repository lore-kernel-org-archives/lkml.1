Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbZLPX4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbZLPX4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762928AbZLPX41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:56:27 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:48909 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762756AbZLPX4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:56:18 -0500
Date: Wed, 16 Dec 2009 15:56:17 -0800
From: Andrew Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Rob Landley <rob@landley.net>
Subject: CONFIG_KPROBES=y build requires gawk
Message-ID: <20091216235617.GA12267@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_KPROBES=y on Ubuntu 9.10 x86_64 default install, I get the
following:

Error: Your awk doesn't support charactor-class.
Please try to use gawk.
  CC      arch/x86/lib/inat.o
arch/x86/lib/inat.c:24:25: error: inat-tables.c: No such file or directory
arch/x86/lib/inat.c: In function "inat_get_opcode_attribute":
arch/x86/lib/inat.c:29: error: "inat_primary_table" undeclared (first use in this function)
arch/x86/lib/inat.c:29: error: (Each undeclared identifier is reported only once
arch/x86/lib/inat.c:29: error: for each function it appears in.)
arch/x86/lib/inat.c: In function "inat_get_escape_attribute":
arch/x86/lib/inat.c:44: error: "inat_escape_tables" undeclared (first use in this function)
arch/x86/lib/inat.c: In function "inat_get_group_attribute":
arch/x86/lib/inat.c:67: error: "inat_group_tables" undeclared (first use in this function)
arch/x86/lib/inat.c: In function "inat_get_avx_attribute":
arch/x86/lib/inat.c:85: error: "inat_avx_tables" undeclared (first use in this function)
make[1]: *** [arch/x86/lib/inat.o] Error 1
make: *** [arch/x86/lib] Error 2

Either CONFIG_KPROBES=n or 'apt-get install gawk' does the trick, but is
this intentional?

If it is, the following documentation patch should be applied.

-andy

---
From: Andy Isaacson <adi@hexapodia.org>
Date: Wed, 16 Dec 2009 15:51:30 -0800
Subject: [PATCH] Document requirement for gawk.

Signed-off-by: Andy Isaacson <adi@hexapodia.org>
---
 Documentation/Changes |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index 6d0f1ef..8d55162 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -49,6 +49,7 @@ o  oprofile               0.9                     # oprofiled --version
 o  udev                   081                     # udevinfo -V
 o  grub                   0.93                    # grub --version
 o  mcelog		  0.6
+o  gawk                   3.0                     # awk --version
 
 Kernel compilation
 ==================
-- 
1.6.5.3

