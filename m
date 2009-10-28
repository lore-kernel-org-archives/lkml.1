Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZJ1Wx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZJ1Wx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZJ1Wx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:53:58 -0400
Received: from mailgw.kvados.cz ([194.213.53.146]:41566 "EHLO mailgw.kvados.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbZJ1Wx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:53:58 -0400
From: Milan Dadok <milan@dadok.name>
To: "'Greg KH'" <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, "'Hank Janssen'" <hjanssen@microsoft.com>,
       "'Haiyang Zhang'" <haiyangz@microsoft.com>
References: <001601ca581d$5390e0e0$fab2a2a0$@name> <20091028223114.GA25962@suse.de>
In-Reply-To: <20091028223114.GA25962@suse.de>
Subject: RE: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include
Date: Wed, 28 Oct 2009 23:54:00 +0100
Message-ID: <001701ca5821$8a52aec0$9ef80c40$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpYHmwjvA4W5MYYTNeyw85MdZItawAAEwAg
Content-Language: cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's gentoo
Primary I was working on linux-2.6.31-gentoo 
gcc-config  -l
 [1] i686-pc-linux-gnu-4.3.2 *

10 Sep 2009; Mike Pagano <mpagano@gentoo.org>
  +gentoo-sources-2.6.31.ebuild:
  Initial 2.6.31 release including the fbcondecor patch,, a paoatch to
  enable control of the unaligned access control policy from sysctl and a
  patch for bad block relocation support for LiveCD users.

I already suspected some error on my side, therefor I installed vanilla
2.6.32-r5
Because I cannot made it to compile without #include, I send third patch.

Now I tried it again - and it look like only #include in osd.h is missing.
In ChannelMgmt.h is not ...

My error is (#include workqueue.h commented in osd.h)
# make SUBDIR=drivers/staging/hv CONFIG_DEBUG_SECTION_MISMATCH=y modules

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/staging/hv/blkvsc_drv.o
  CC [M]  drivers/staging/hv/BlkVsc.o
In file included from drivers/staging/hv/BlkVsc.c:24:
drivers/staging/hv/osd.h:68: warning: 'struct workqueue_struct' declared
inside parameter list
drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
declaration, which is probably not what you want
  CC [M]  drivers/staging/hv/netvsc_drv.o
  CC [M]  drivers/staging/hv/NetVsc.o
In file included from drivers/staging/hv/NetVsc.c:24:
drivers/staging/hv/osd.h:68: warning: 'struct workqueue_struct' declared
inside parameter list
drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
declaration, which is probably not what you want
  CC [M]  drivers/staging/hv/RndisFilter.o
In file included from drivers/staging/hv/RndisFilter.c:24:
drivers/staging/hv/osd.h:68: warning: 'struct workqueue_struct' declared
inside parameter list
drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
declaration, which is probably not what you want
  CC [M]  drivers/staging/hv/storvsc_drv.o
  CC [M]  drivers/staging/hv/StorVsc.o
In file included from drivers/staging/hv/StorVsc.c:25:
drivers/staging/hv/osd.h:68: warning: 'struct workqueue_struct' declared
inside parameter list
drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
declaration, which is probably not what you want
  CC [M]  drivers/staging/hv/vmbus_drv.o
  CC [M]  drivers/staging/hv/osd.o
  CC [M]  drivers/staging/hv/Vmbus.o
In file included from drivers/staging/hv/Vmbus.c:24:
drivers/staging/hv/osd.h:68: warning: 'struct workqueue_struct' declared
inside parameter list
drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
declaration, which is probably not what you want
In file included from drivers/staging/hv/Channel.h:28,
                 from drivers/staging/hv/VmbusPrivate.h:30,
                 from drivers/staging/hv/Vmbus.c:27:
drivers/staging/hv/ChannelMgmt.h:232: error: field 'poll_timer' has
incomplete type
drivers/staging/hv/Vmbus.c: In function 'VmbusOnMsgDPC':
drivers/staging/hv/Vmbus.c:193: warning: passing argument 1 of
'osd_schedule_callback' from incompatible pointer type
make[3]: *** [drivers/staging/hv/Vmbus.o] Error 1
make[2]: *** [drivers/staging/hv] Error 2
make[1]: *** [drivers/staging] Error 2
make: *** [drivers] Error 2

Milan

PS. I have another error with 2.6.32-rc5 - if there is some WARNING mismatch
in reference, then *.ko is not copied to
/lib/modules/2.6.32-rc5/kernel/drivers/staging/hv/
It is correct behaivour of kernel build system?
2.6.31 without warning always copied .ko files to /lib

At 23:46 run
snow# make SUBDIR=drivers/staging/hv CONFIG_DEBUG_SECTION_MISMATCH=y modules
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/staging/hv/blkvsc_drv.o
  CC [M]  drivers/staging/hv/BlkVsc.o
  CC [M]  drivers/staging/hv/netvsc_drv.o
  CC [M]  drivers/staging/hv/NetVsc.o
  CC [M]  drivers/staging/hv/RndisFilter.o
  CC [M]  drivers/staging/hv/storvsc_drv.o
  CC [M]  drivers/staging/hv/StorVsc.o
  CC [M]  drivers/staging/hv/vmbus_drv.o
  CC [M]  drivers/staging/hv/osd.o
  CC [M]  drivers/staging/hv/Vmbus.o
  CC [M]  drivers/staging/hv/Hv.o
  CC [M]  drivers/staging/hv/Connection.o
  CC [M]  drivers/staging/hv/Channel.o
  CC [M]  drivers/staging/hv/ChannelMgmt.o
  CC [M]  drivers/staging/hv/ChannelInterface.o
  CC [M]  drivers/staging/hv/RingBuffer.o
  LD [M]  drivers/staging/hv/hv_vmbus.o
  LD [M]  drivers/staging/hv/hv_storvsc.o
  LD [M]  drivers/staging/hv/hv_blkvsc.o
  LD [M]  drivers/staging/hv/hv_netvsc.o
  Building modules, stage 2.
  MODPOST 401 modules
WARNING: drivers/net/virtio_net.o(.data+0x4c): Section mismatch in reference
from the variable virtio_net to the function .devexit.text:virtnet_remove()
The variable virtio_net references
the function __devexit virtnet_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

  CC      drivers/staging/hv/hv_blkvsc.mod.o
  LD [M]  drivers/staging/hv/hv_blkvsc.ko
  CC      drivers/staging/hv/hv_netvsc.mod.o
  LD [M]  drivers/staging/hv/hv_netvsc.ko
  CC      drivers/staging/hv/hv_storvsc.mod.o
  LD [M]  drivers/staging/hv/hv_storvsc.ko
  LD [M]  drivers/staging/hv/hv_vmbus.ko
snow hv # ll /lib/modules/2.6.32-rc5/kernel/drivers/staging/hv/
total 156
-rw-r--r-- 1 root root 31415 Oct 28 23:16 hv_blkvsc.ko
-rw-r--r-- 1 root root 34863 Oct 28 23:16 hv_netvsc.ko
-rw-r--r-- 1 root root 26949 Oct 28 23:16 hv_storvsc.ko
-rw-r--r-- 1 root root 53503 Oct 28 23:16 hv_vmbus.ko


-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Wednesday, October 28, 2009 11:31 PM
To: Milan Dadok
Cc: linux-kernel@vger.kernel.org; 'Hank Janssen'; 'Haiyang Zhang'
Subject: Re: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include

On Wed, Oct 28, 2009 at 11:23:50PM +0100, Milan Dadok wrote:
> Add missing #include to make hv module compile successfull.

What is the platform that causes this patch to be needed?  This doesn't
seem to be needed in my testing here.

thanks,

greg k-h

