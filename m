Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbXKCPPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbXKCPPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 11:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbXKCPPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 11:15:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46800 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbXKCPPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 11:15:03 -0400
Date: Sat, 3 Nov 2007 16:14:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arch/ppc: Remove an unnecessary pci_dev_put.
Message-ID: <Pine.LNX.4.64.0711031613020.7633@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Remove an unnecessary pci_dev_put.  pci_dev_put is called implicitly by the
subsequent call to pci_get_device.

The problem was detected using the following semantic patch, and corrected
by hand.

@@
expression dev;
expression E;
@@

- pci_dev_put(dev)
   ... when != dev = E
- pci_get_device(...,dev)


Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -up a/arch/ppc/platforms/prep_pci.c b/arch/ppc/platforms/prep_pci.c
--- a/arch/ppc/platforms/prep_pci.c	2007-11-03 15:25:45.000000000 +0100
+++ b/arch/ppc/platforms/prep_pci.c	2007-11-03 15:25:59.000000000 +0100
@@ -1099,7 +1099,6 @@ prep_pib_init(void)
  				pci_write_config_byte(dev, 0x43, reg);
  			}
  		}
-		pci_dev_put(dev);
  	}

  	if ((dev = pci_get_device(PCI_VENDOR_ID_WINBOND,
