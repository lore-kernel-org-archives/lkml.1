Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXEEUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXEEUXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXEEUXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:23:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:38426 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933327AbXEEUXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:23:20 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18bms00jaMbLmt1WiiPxaX4pWHvJhOxxS42jlsiEf
	BUZoiKE9qDrTQZ
Date: Sat, 5 May 2007 22:23:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Niklas Steinkamp <NiSteinkamp@web.de>
cc: garloff@suse.de, linux-kernel@vger.kernel.org
Subject: Re: DC390: replace pci_module_init in dc390_module_init
In-Reply-To: <463C785B.10007@web.de>
Message-ID: <Pine.LNX.4.60.0705052221460.4773@poirot.grange>
References: <463C785B.10007@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007, Niklas Steinkamp wrote:

> while compiling the DC930 SCSI driver, i got this message:
> 
> drivers/built-in.o: In function `dc390_module_init':
> tmscsim.c:(.init.text+0x124c4): undefined reference to `pci_module_init'
> make: *** [.tmp_vmlinux1] Fehler 1
> 
> so i replaced "pci_module_init" with "pci_register_device"
> and it works just fine.
> --------------------------
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index a583e89..3158949 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -2680,7 +2680,7 @@ static int __init dc390_module_init(void)
>                 printk (KERN_INFO "DC390: Using safe settings.\n");
>         }
> 
> -       return pci_module_init(&dc390_driver);
> +       return pci_register_driver(&dc390_driver);
>  }
> 
>  static void __exit dc390_module_exit(void)

Thanks for the patch, but this is already fixed in -mm tree: 
http://marc.info/?l=linux-scsi&m=117757368229767&w=2

Thanks
Guennadi
---
Guennadi Liakhovetski
