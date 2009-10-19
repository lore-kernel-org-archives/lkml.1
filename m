Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZJSOcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZJSOcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZJSOcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:32:35 -0400
Received: from icculus.org ([67.106.77.212]:51073 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304AbZJSOce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:32:34 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 10:32:34 EDT
Date: Mon, 19 Oct 2009 10:25:43 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: linux-kernel@vger.kernel.org
Subject: [PATCH] binfmt_elf: Reorder objects in Makefile to favor platform
 default.
Message-ID: <alpine.DEB.2.00.0910190415430.13303@andre.icculuslan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reordered object list so compat_binfmt_elf.o comes first. This will make it
call register_binfmt() first, inserting it at the end of the list.

Now the kernel will try the compatibility formats as a backup if the actual
system format rejects the binary. As almost all binaries loaded won't be
compatibility formats, this saves a few cycles for each process.

Signed-off-by: Ryan C. Gordon <icculus@icculus.org>
---
 fs/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index af6d047..173d153 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -40,8 +40,9 @@ obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
 # binfmt_script is always there
 obj-y				+= binfmt_script.o
 
-obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
+# List compat_* first, so they insert at end of the list, and are tried last.
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
+obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
-- 
1.6.0.4

