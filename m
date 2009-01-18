Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZARVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZARVR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZARVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:17:19 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53543 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZARVRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:17:19 -0500
Date: Sun, 18 Jan 2009 22:17:16 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: sam@ravnborg.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kbuild: install to a single directory
Message-ID: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



This proposed change will collect all kernel modules in the
single directory, e.g. /lib/modules/2.6.29-rc2/kernel/, without
any further directory structure. About 475 inodes (with
almost-allmodconfig) less are used, which should result
in faster directory traversal (less seeks).

---8<---
parent 53c67f8b25a2e6b8b69ac235372cdda036070cfc (v2.6.29-rc2-22-g53c67f8)
commit 5e61b62737a2184742c4d63c9cdd6c5450ec4034
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Jan 17 20:58:58 2009 +0100

kbuild: install to a single directory

Most of the directory hierarchy in /lib/modules/$(uname -r)/kernel/
seems redundant to me, so just collapse it all and stuff all files in
that single directory. No module name can be used twice anyway, so no
collision will occur.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 scripts/Makefile.modinst |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index 4c7c163..5b34e82 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -25,7 +25,7 @@ quiet_cmd_modules_install = INSTALL $@
 INSTALL_MOD_DIR ?= extra
 ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(patsubst %/,%,$(KBUILD_EXTMOD)),,$(@D))
 
-modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
+modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/)
 
 $(modules):
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
-- 
# Created with git-export-patch
