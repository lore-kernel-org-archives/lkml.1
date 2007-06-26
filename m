Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbXFZUY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbXFZUY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbXFZUYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:24:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34892 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031AbXFZUYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:24:21 -0400
Date: Tue, 26 Jun 2007 13:26:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt_Domsch@dell.com
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: EDD build error
Message-Id: <20070626132622.3226261a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CONFIG_EDD does not depend on PCI, but edd.c uses pci_* interface
functions, resulting in:

  CC [M]  drivers/firmware/edd.o
drivers/firmware/edd.c: In function 'edd_get_pci_dev':
drivers/firmware/edd.c:672: warning: implicit declaration of function 'pci_get_bus_and_slot'
drivers/firmware/edd.c:673: warning: return makes pointer from integer without a cast
...
ERROR: "pci_get_bus_and_slot" [drivers/firmware/edd.ko] undefined!
make[1]: *** [__modpost] Error 1


Should EDD depend on PCI or should some parts of edd.c be stubbed?


(This is in 2.6.22-rc4-mm2 FWIW.)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
