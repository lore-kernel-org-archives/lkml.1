Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYGPHjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYGPHjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYGPHiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:38:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36293 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYGPHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:38:51 -0400
Date: Wed, 16 Jul 2008 16:43:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-07-15-15-39 uploaded
Message-Id: <20080716164346.35c6a692.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200807152240.m6FMeErt024703@imap1.linux-foundation.org>
References: <200807152240.m6FMeErt024703@imap1.linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 15:40:14 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-07-15-15-39 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.26:
> 

booted succesfully with my usual config.
but not with allmodconfig. (I'm now trying various configs.)

Compile time trouble is here.

allmodconfig complile report on x86-64.
==
compile troubles.

- CONFIG_MOXA_SMARTIO .......no idea.

  CC [M]  drivers/char/mxser.o
drivers/char/mxser.c: In function 'mxser_flush_chars':
drivers/char/mxser.c:1306: error: 'struct mxser_port' has no member named 'xmit_buf'
drivers/char/mxser.c: In function 'mxser_ioctl_special':
drivers/char/mxser.c:1640: error: 'GMStatus' undeclared (first use in this function)
drivers/char/mxser.c:1640: error: (Each undeclared identifier is reported only once
drivers/char/mxser.c:1640: error: for each function it appears in.)
drivers/char/mxser.c:1701: error: 'mon_data_ext' undeclared (first use in this function)
drivers/char/mxser.c:1720: error: 'me' undeclared (first use in this function)
drivers/char/mxser.c:1678: warning: unused variable 'shiftbit'
make[2]: *** [drivers/char/mxser.o] Error 1

CONFIG_FB_EINK_APOLLO .... seems only for ARM ?
  CC [M]  drivers/video/eink_apollofb.o
drivers/video/eink_apollofb.c:36:32: error: asm/arch/regs-gpio.h: No such file or directory
drivers/video/eink_apollofb.c:37:26: error: asm/hardware.h: No such file or dire#tory

CONFIG_MFD_TC6393XB  .....seems only for ARM ?
  CC      drivers/mfd/tc6393xb.o
drivers/mfd/tc6393xb.c: In function 'tc6393xb_attach_irq':
drivers/mfd/tc6393xb.c:324: error: implicit declaration of function 'set_irq_flags'
drivers/mfd/tc6393xb.c:324: error: 'IRQF_VALID' undeclared (first use in this function)
drivers/mfd/tc6393xb.c:324: error: (Each undeclared identifier is reported only once
drivers/mfd/tc6393xb.c:324: error: for each function it appears in.)
drivers/mfd/tc6393xb.c:324: error: 'IRQF_PROBE' undeclared (first use in this function)
drivers/mfd/tc6393xb.c:327: error: 'IRQT_FALLING' undeclared (first use in this function)
make[2]: *** [drivers/mfd/tc6393xb.o] Error 1


Seems failed to catch this change.
patches/dma-mapping-add-the-device-argument-to-dma_mapping_error.patch

drivers/mmc/host/sdhci.c: In function 'sdhci_adma_table_pre':
drivers/mmc/host/sdhci.c:363: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
drivers/mmc/host/sdhci.c:363: error: too few arguments to function 'dma_mapping_error'
drivers/mmc/host/sdhci.c:464: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
drivers/mmc/host/sdhci.c:464: error: too few arguments to function 'dma_mapping_error'
make[3]: *** [drivers/mmc/host/sdhci.o] Error 1

==

Regards,
-Kame


