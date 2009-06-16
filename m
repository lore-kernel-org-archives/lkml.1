Return-Path: <linux-kernel-owner+w=401wt.eu-S936893AbZFPGBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936893AbZFPGBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935914AbZFPFvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:33 -0400
Received: from kroah.org ([198.145.64.141]:48426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935892AbZFPFvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 45/64] PCIE: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:34 -0700
Message-Id: <1245131213-24168-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Cc: linux-pci@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pcie/portdrv_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index e399825..13ffdc3 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -275,7 +275,7 @@ static void pcie_device_init(struct pci_dev *parent, struct pcie_device *dev,
 	memset(device, 0, sizeof(struct device));
 	device->bus = &pcie_port_bus_type;
 	device->driver = NULL;
-	device->driver_data = NULL;
+	dev_set_drvdata(device, NULL);
 	device->release = release_pcie_device;	/* callback to free pcie dev */
 	dev_set_name(device, "%s:pcie%02x",
 		 pci_name(parent), get_descriptor_id(port_type, service_type));
-- 
1.6.3.2

