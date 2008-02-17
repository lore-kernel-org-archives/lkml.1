Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYBQMaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYBQMaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYBQMXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38360 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436AbYBQMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Len Brown <len.brown@intel.com>
Subject: [PATCH 26/27] acpi: fix section mismatch in acpi_pci_root_add
Date: Sun, 17 Feb 2008 13:23:03 +0100
Message-Id: <1203250984-11285-26-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x550e85): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()

acpi_pci_root_add uses a __devinit annotated function and
it looks like annotating it __devinit too is the correct fix.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Len Brown <len.brown@intel.com>
---
 drivers/acpi/pci_root.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index f14ff1f..c3fed31 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -184,7 +184,7 @@ static void acpi_pci_bridge_scan(struct acpi_device *device)
 		}
 }
 
-static int acpi_pci_root_add(struct acpi_device *device)
+static int __devinit acpi_pci_root_add(struct acpi_device *device)
 {
 	int result = 0;
 	struct acpi_pci_root *root = NULL;
-- 
1.5.4.rc3.14.g44397

