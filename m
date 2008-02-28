Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYB1I1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYB1I1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYB1I0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:26:44 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:49310 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbYB1I0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:26:43 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>
Date: Thu, 28 Feb 2008 08:26:14 +0000
Message-Id: <1204187174-27143-2-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1204187174-27143-1-git-send-email-ijc@hellion.org.uk>
References: <1204187174-27143-1-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 2/2] x86/xen: Disable DMI parsing in Xen kernel.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/xen/enlighten.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 49e5358..69e11ef 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
+#include <linux/dmi.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
@@ -1209,6 +1210,9 @@ asmlinkage void __init xen_start_kernel(void)
 		? __pa(xen_start_info->mod_start) : 0;
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 
+	/* Disable DMI parsing */
+	dmi_available = 1;
+
 	/* Start the world */
 	start_kernel();
 }
-- 
1.5.4.2

