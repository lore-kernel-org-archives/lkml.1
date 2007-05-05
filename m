Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXEEUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXEEUdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXEEUdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:33:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933265AbXEEUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:33:19 -0400
Date: Sat, 5 May 2007 13:33:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: art@usfltd.com
cc: linux-kernel@vger.kernel.org
Subject: Re: git-tree compilation error "pci_module_init" [drivers/scsi/tmscsim.ko]
 undefined!
In-Reply-To: <20070505092558.joq9kbhn284sc00c@67.106.77.56>
Message-ID: <alpine.LFD.0.98.0705051328100.3819@woody.linux-foundation.org>
References: <20070505092558.joq9kbhn284sc00c@67.106.77.56>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 May 2007, art@usfltd.com wrote:
>
> WARNING: "pci_module_init" [drivers/scsi/tmscsim.ko] undefined!

Ok, that driver needs to be converted to use "pci_register_driver()" 
instead of "pci_module_init()". It's probably the following one-liner, do 
you actually have that hardware to test?

		Linus
---
 drivers/scsi/tmscsim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index a583e89..3158949 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2680,7 +2680,7 @@ static int __init dc390_module_init(void)
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)
