Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZJBCAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZJBCAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZJBBcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:35 -0400
Received: from kroah.org ([198.145.64.141]:32903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbZJBBcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:07 2009
Message-Id: <20091002012407.514610839@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Chiang <achiang@hp.com>, Len Brown <len.brown@intel.com>
Subject: [012/136] ACPI: pci_slot.ko wants a 64-bit _SUN
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=acpi-pci_slot.ko-wants-a-64-bit-_sun.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit 7e24bc1ce669b2876ffa475ea1147f2bb9ffdc52 upstream.

Similar to commit b6adc195 (PCI hotplug: acpiphp wants a 64-bit
_SUN), pci_slot.ko reads and creates sysfs directories based on
the _SUN method.

Certain HP platforms return 64 bits in _SUN. This change to
pci_slot.ko allows us to see the correct sysfs directories.

Reported-by: Chad Smith <chad.smith@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/pci_slot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -57,7 +57,7 @@ ACPI_MODULE_NAME("pci_slot");
 				MY_NAME , ## arg);		\
 	} while (0)
 
-#define SLOT_NAME_SIZE 20		/* Inspired by #define in acpiphp.h */
+#define SLOT_NAME_SIZE 21		/* Inspired by #define in acpiphp.h */
 
 struct acpi_pci_slot {
 	acpi_handle root_handle;	/* handle of the root bridge */
@@ -149,7 +149,7 @@ register_slot(acpi_handle handle, u32 lv
 		return AE_OK;
 	}
 
-	snprintf(name, sizeof(name), "%u", (u32)sun);
+	snprintf(name, sizeof(name), "%llu", sun);
 	pci_slot = pci_create_slot(pci_bus, device, name, NULL);
 	if (IS_ERR(pci_slot)) {
 		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));


