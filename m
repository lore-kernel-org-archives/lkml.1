Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXDVOmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXDVOmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030928AbXDVOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:42:42 -0400
Received: from www17.your-server.de ([213.133.104.17]:3475 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283AbXDVOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:42:41 -0400
Message-ID: <462B7449.8050908@m3y3r.de>
Date: Sun, 22 Apr 2007 16:42:17 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386-efi fix /proc/iomem type for kexec-tools
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kexec-tools check for "System RAM".

diff --git a/arch/i386/kernel/efi.c b/arch/i386/kernel/efi.c
index 8f9c624..307156d 100644
--- a/arch/i386/kernel/efi.c
+++ b/arch/i386/kernel/efi.c
@@ -638,8 +638,13 @@ efi_initialize_iomem_resources(struct resource
*code_resource,
             res->name = "Runtime Service Data";
             break;
         case EFI_CONVENTIONAL_MEMORY:
-            res->name = "Conventional Memory";
-            break;
+                        if (md->attribute & EFI_MEMORY_WP) {
+                                res->name = "System ROM";
+                                res->flags |= IORESOURCE_READONLY;
+                        } else {
+                                res->name = "System RAM";
+                        }
+                        break;
         case EFI_UNUSABLE_MEMORY:
             res->name = "Unusable Memory";
             break;

