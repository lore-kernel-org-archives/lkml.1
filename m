Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYJPFD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYJPFD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 01:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYJPFDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 01:03:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbYJPFDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 01:03:11 -0400
Date: Wed, 15 Oct 2008 22:02:47 -0700 (PDT)
Message-Id: <20081015.220247.262683261.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: dan.j.williams@intel.com, tiwai@suse.de, linux-ext4@vger.kernel.org,
       netdev@vger.kernel.org, linux-ide@vger.kernel.org, bzolnier@gmail.com,
       marek.vasut@gmail.com, dwmw2@infradead.org, mark.fasheh@oracle.com,
       ralf@linux-mips.org, mchehab@infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: powerpc allmodconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081015213337.a99a9595.akpm@linux-foundation.org>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 15 Oct 2008 21:33:37 -0700

> kernel/resource.c: In function '__reserve_region_with_split':
> kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
> kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
> kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'
> kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'resource_size_t'

Known issue, Ben wants to add a new variant of %pX in order to print resources so that
resource_size_t vs. unsigned long stuff doesn't matter like this any more.

> net/dccp/options.c: In function 'dccp_parse_options':
> net/dccp/options.c:67: warning: 'value' may be used uninitialized in this function

Known issue, not trivial to fix, gcc is just being incredibly silly here as it
can't see all of the control flow.

> drivers/dma/ioat_dca.c: In function 'dca_enabled_in_bios':
> drivers/dma/ioat_dca.c:81: error: implicit declaration of function 'cpuid_eax'
> drivers/dma/ioat_dca.c: In function 'system_has_dca_enabled':
> drivers/dma/ioat_dca.c:91: error: implicit declaration of function 'boot_cpu_has'
> drivers/dma/ioat_dca.c:91: error: 'X86_FEATURE_DCA' undeclared (first use in this function)
> drivers/dma/ioat_dca.c:91: error: (Each undeclared identifier is reported only once
> drivers/dma/ioat_dca.c:91: error: for each function it appears in.)
> drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
> drivers/dma/ioat_dca.c:190: error: implicit declaration of function 'cpu_physical_id'

Known issue.  I tried to ping Jeff Garzik about doing a driver bug fix run in
order to fix this, but he hasn't shown any signs of life.

So I'll do it myself later tonight. :-/

> net/sched/sch_generic.c: In function 'dev_watchdog':
> net/sched/sch_generic.c:224: warning: unused variable 'drivername'

Sucky, if WARN_ONCE() evaluates to nothing the sprintf() string buffer
on the stack looks unused.

> drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_read':
> drivers/rtc/rtc-ds1286.c:33: error: implicit declaration of function '__raw_readl'
> drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_write':
> drivers/rtc/rtc-ds1286.c:38: error: implicit declaration of function '__raw_writel'
> drivers/rtc/rtc-ds1286.c: In function 'ds1286_probe':
> drivers/rtc/rtc-ds1286.c:345: error: implicit declaration of function 'ioremap'
> drivers/rtc/rtc-ds1286.c:345: warning: assignment makes pointer from integer without a cast
> drivers/rtc/rtc-ds1286.c:365: error: implicit declaration of function 'iounmap'

Missing asm/io.h include.

> drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
> drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
> drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
> drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
> drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
> drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
> drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'

Likewise.

> drivers/net/wireless/libertas_tf/if_usb.c: In function '__if_usb_submit_rx_urb':
> drivers/net/wireless/libertas_tf/if_usb.c:334: warning: cast to pointer from integer of different size

I've seen this one on sparc64 too, I think the arg is totally unused in the end
for this callback control flow and we can just use NULL or zero instead.
