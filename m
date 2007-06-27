Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbXF0Rva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbXF0Rva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXF0RvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:51:24 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:50558 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbXF0RvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:51:23 -0400
Subject: Re: [PATCH] Documentation/firmware_class/firmware_sample_driver.c
From: Marcel Holtmann <marcel@holtmann.org>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org, Manuel Estrada Sainz <ranty@debian.org>
In-Reply-To: <46827B20.6000501@control.lth.se>
References: <46827B20.6000501@control.lth.se>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 19:49:29 +0200
Message-Id: <1182966569.9499.1.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anders,

> Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>
> 
> Minor modifications to make the example load and unload without Oops
> 
> This is what unpatched version generates with 2.6.21.3
> 
> kernel: Oops: 0000 [#2]
> ...
> kernel: Call Trace:
> kernel:  [<c04ae541>] sysfs_create_dir+0x49/0x63
> kernel:  [<c04e76ae>] kobject_shadow_add+0xd5/0x17d
> kernel:  [<c04e7908>] kobject_set_name+0x2b/0x92
> kernel:  [<c0556444>] device_add+0x9a/0x58e
> kernel:  [<c0620b65>] klist_init+0x23/0x2e
> kernel:  [<c055bfee>] _request_firmware+0x116/0x29f
> kernel:  [<c062149f>] wait_for_completion+0x8b/0x93
> kernel:  [<c055c20b>] request_firmware+0xf/0x11
> kernel:  [<e09420d9>] sample_init+0x59/0xc0 [firmware_sample_driver]
> kernel:  [<c0446c92>] sys_init_module+0x16b7/0x17ee
> kernel:  [<c04294de>] printk+0x0/0x1f
> kernel:  [<c0488436>] mntput_no_expire+0x11/0x6e
> kernel:  [<c0404fa8>] syscall_call+0x7/0xb
> 
> 
> 
> diff -u Documentation/firmware_class/firmware_sample_driver.c
> /tmp/fw/firmware_sample_driver.c
> --- Documentation/firmware_class/firmware_sample_driver.c       2007-05-24
> 23:22:47.000000000 +0200
> +++ /tmp/fw/firmware_sample_driver.c    2007-06-27 16:51:16.000000000 +0200
> @@ -15,11 +15,16 @@
> 
>  #include "linux/firmware.h"
> 
> +static void ghost_release(struct device *dev)
> +{
> +       printk(KERN_DEBUG "firmware_sample_driver: ghost_release\n");
> +}
> +

I know it is a sample driver, but you can't do that. You have to
allocate the device and then free it here.

Regards

Marcel


