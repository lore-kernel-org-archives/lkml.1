Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0BOQrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:47:21 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:63420 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0BOQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:47:18 -0500
Message-ID: <4B797A5C.8020306@oracle.com>
Date: Mon, 15 Feb 2010 08:46:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for February 15 (staging/dt3155)
References: <20100215194926.667a3de8.sfr@canb.auug.org.au>
In-Reply-To: <20100215194926.667a3de8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B797A7F.020B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/10 00:49, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100212:


1/  dt3155 tries to use arbitrary divide & modulus.  This fails on i386:

ERROR: "__udivdi3" [drivers/staging/dt3155/dt3155.ko] undefined!
ERROR: "__umoddi3" [drivers/staging/dt3155/dt3155.ko] undefined!

2/  since DT3155 depends on PCI, these lines can be dropped from dt3155_drv.c:

-#ifndef CONFIG_PCI
-#error  "DT3155 :  Kernel PCI support not enabled (DT3155 drive requires PCI)"
-#endif

3/  header files need to be included even when built-in instead of defined(MODULE)
to eliminate build errors:

drivers/staging/dt3155/dt3155_drv.c:1047: error: implicit declaration of function 'request_irq'
drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_SHARED' undeclared (first use in this function)
drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_DISABLED' undeclared (first use in this function)
drivers/staging/dt3155/dt3155_drv.c:1091: error: implicit declaration of function 'free_irq'


-#ifdef MODULE
 #include <linux/module.h>
 #include <linux/interrupt.h>
 
 
 MODULE_LICENSE("GPL");
 
-#endif


-- 
~Randy
