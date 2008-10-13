Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYJML1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYJML1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbYJML1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:27:35 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49015 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760012AbYJML1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:27:34 -0400
Date: Mon, 13 Oct 2008 14:26:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Brice Goglin <brice@myri.com>, Jeff Garzik <jgarzik@redhat.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [BUILD_FAILURE] 2.6.27-git2 - allyesconfig on powerpc selects
	CONFIG_INTEL_IOATDMA=y
Message-ID: <20081013112631.GD29938@cs181140183.pp.htv.fi>
References: <20081013101559.GA14372@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081013101559.GA14372@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 03:45:59PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
>    2.6.27-git2 kernel build fails, while building the kernel with
> allyesconfig option. The allyesconfig selects CONFIG_INTEL_IOATDMA=y
> 
> CC   drivers/dma/ioat_dca.o
> drivers/dma/ioat_dca.c: In function âdca_enabled_in_biosâ:
> drivers/dma/ioat_dca.c:81: error: implicit declaration of function âcpuid_eaxâ
> drivers/dma/ioat_dca.c: In function âsystem_has_dca_enabledâ:
> drivers/dma/ioat_dca.c:91: error: implicit declaration of function âboot_cpu_hasâ
> drivers/dma/ioat_dca.c:91: error: âX86_FEATURE_DCAâ undeclared (first use in this function)
> drivers/dma/ioat_dca.c:91: error: (Each undeclared identifier is reported only once
> drivers/dma/ioat_dca.c:91: error: for each function it appears in.)
> drivers/dma/ioat_dca.c: In function âioat_dca_get_tagâ:
> drivers/dma/ioat_dca.c:190: error: implicit declaration of function âcpu_physical_idâ
> make[2]: *** [drivers/dma/ioat_dca.o] Error 1
> make[1]: *** [drivers/dma] Error 2
> make: *** [drivers] Error 2
>...

Thanks for the report, the MYRI10GE and IXGBE commits that introduced 
the select's are really broken.

For fixing it I need to know the intended semantics.

Brian, Jesse, is it OK to limit the drivers to m with 
CONFIG_INTEL_IOATDMA=m ?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

