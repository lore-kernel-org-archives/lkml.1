Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbXEEQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbXEEQg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbXEEQg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:36:27 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:39590 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933936AbXEEQg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:36:27 -0400
Message-ID: <463C785B.10007@web.de>
Date: Sat, 05 May 2007 14:28:11 +0200
From: Niklas Steinkamp <NiSteinkamp@web.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: garloff@suse.de, linux-kernel@vger.kernel.org
Subject: DC390: replace pci_module_init in dc390_module_init
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19Prv+GN91C63+OHdi30TK0wjLxPz5412/le006
	BGcKmgE0gGXYkO3HDaENdIpkR8mR9SZo9RrPGGccGiXpE+ZqG5
	nwADspp4g=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while compiling the DC930 SCSI driver, i got this message:

drivers/built-in.o: In function `dc390_module_init':
tmscsim.c:(.init.text+0x124c4): undefined reference to `pci_module_init'
make: *** [.tmp_vmlinux1] Fehler 1

so i replaced "pci_module_init" with "pci_register_device"
and it works just fine.
--------------------------

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index a583e89..3158949 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2680,7 +2680,7 @@ static int __init dc390_module_init(void)
                 printk (KERN_INFO "DC390: Using safe settings.\n");
         }

-       return pci_module_init(&dc390_driver);
+       return pci_register_driver(&dc390_driver);
  }

  static void __exit dc390_module_exit(void)
