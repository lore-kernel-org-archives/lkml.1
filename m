Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYJPGIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYJPGIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJPGIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:08:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:31617 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbYJPGIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:08:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,422,1220252400"; 
   d="scan'208";a="60649210"
Subject: Re: powerpc allmodconfig
From: Dan Williams <dan.j.williams@intel.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, tiwai@suse.de, linux-ext4@vger.kernel.org,
       netdev@vger.kernel.org, linux-ide@vger.kernel.org, bzolnier@gmail.com,
       marek.vasut@gmail.com, dwmw2@infradead.org, mark.fasheh@oracle.com,
       ralf@linux-mips.org, mchehab@infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, jesse.brandeburg@intel.com
In-Reply-To: <20081015.220247.262683261.davem@davemloft.net>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	 <20081015.220247.262683261.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 23:08:12 -0700
Message-Id: <1224137292.26782.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-10-15 at 22:02 -0700, David Miller wrote:
> > drivers/dma/ioat_dca.c: In function 'dca_enabled_in_bios':
> > drivers/dma/ioat_dca.c:81: error: implicit declaration of function 'cpuid_eax'
> > drivers/dma/ioat_dca.c: In function 'system_has_dca_enabled':
> > drivers/dma/ioat_dca.c:91: error: implicit declaration of function 'boot_cpu_has'
> > drivers/dma/ioat_dca.c:91: error: 'X86_FEATURE_DCA' undeclared (first use in this function)
> > drivers/dma/ioat_dca.c:91: error: (Each undeclared identifier is reported only once
> > drivers/dma/ioat_dca.c:91: error: for each function it appears in.)
> > drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
> > drivers/dma/ioat_dca.c:190: error: implicit declaration of function 'cpu_physical_id'
> 
> Known issue.  I tried to ping Jeff Garzik about doing a driver bug fix run in
> order to fix this, but he hasn't shown any signs of life.
> 
> So I'll do it myself later tonight. :-/
> 
The following seems to fix this up...

---snip--->
ixgbe, myri10ge: INTEL_IOATDMA can only be selected when X86=y

From: Dan Williams <dan.j.williams@intel.com>

The INTEL_IOATDMA symbol depends on x86. 'select' ignores this
dependency.

Cc: Brice Goglin <brice@myri.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/net/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 1d8af33..84983f8 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2410,7 +2410,7 @@ config IXGBE
 	tristate "Intel(R) 10GbE PCI Express adapters support"
 	depends on PCI && INET
 	select INET_LRO
-	select INTEL_IOATDMA
+	select INTEL_IOATDMA if X86
 	---help---
 	  This driver supports Intel(R) 10GbE PCI Express family of
 	  adapters.  For more information on how to identify your adapter, go
@@ -2462,7 +2462,7 @@ config MYRI10GE
 	select FW_LOADER
 	select CRC32
 	select INET_LRO
-	select INTEL_IOATDMA
+	select INTEL_IOATDMA if X86
 	---help---
 	  This driver supports Myricom Myri-10G Dual Protocol interface in
 	  Ethernet mode. If the eeprom on your board is not recent enough,


