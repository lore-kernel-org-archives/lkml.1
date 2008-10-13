Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYJMMCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYJMMCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbYJMMCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:02:22 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1873 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755785AbYJMMCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:02:22 -0400
Message-ID: <48F338D2.9080300@myri.com>
Date: Mon, 13 Oct 2008 14:02:26 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [BUILD_FAILURE] 2.6.27-git2 - allyesconfig on powerpc selects
 CONFIG_INTEL_IOATDMA=y
References: <20081013101559.GA14372@linux.vnet.ibm.com> <20081013112631.GD29938@cs181140183.pp.htv.fi>
In-Reply-To: <20081013112631.GD29938@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Oct 13, 2008 at 03:45:59PM +0530, Kamalesh Babulal wrote:
>   
>> Hi,
>>
>>    2.6.27-git2 kernel build fails, while building the kernel with
>> allyesconfig option. The allyesconfig selects CONFIG_INTEL_IOATDMA=y
>>
>> CC   drivers/dma/ioat_dca.o
>> drivers/dma/ioat_dca.c: In function âdca_enabled_in_biosâ:
>> drivers/dma/ioat_dca.c:81: error: implicit declaration of function âcpuid_eaxâ
>> drivers/dma/ioat_dca.c: In function âsystem_has_dca_enabledâ:
>> drivers/dma/ioat_dca.c:91: error: implicit declaration of function âboot_cpu_hasâ
>> drivers/dma/ioat_dca.c:91: error: âX86_FEATURE_DCAâ undeclared (first use in this function)
>> drivers/dma/ioat_dca.c:91: error: (Each undeclared identifier is reported only once
>> drivers/dma/ioat_dca.c:91: error: for each function it appears in.)
>> drivers/dma/ioat_dca.c: In function âioat_dca_get_tagâ:
>> drivers/dma/ioat_dca.c:190: error: implicit declaration of function âcpu_physical_idâ
>> make[2]: *** [drivers/dma/ioat_dca.o] Error 1
>> make[1]: *** [drivers/dma] Error 2
>> make: *** [drivers] Error 2
>> ...
>>     
>
> Thanks for the report, the MYRI10GE and IXGBE commits that introduced 
> the select's are really broken.
>
> For fixing it I need to know the intended semantics.
>
> Brian, Jesse, is it OK to limit the drivers to m with 
> CONFIG_INTEL_IOATDMA=m ?
>   

I think I would rather drop DCA from myri10ge if IOATDMA=m while
myri10ge=y. What's the simplest way to do so?

When Jesse told me to commit this in myri10ge, I thought it would be
nice to have DCA work the same than NETDMA/DMAengine does: you can have
NETDMA enabled without IOATDMA (either not built at all, or just not
loaded). You just don't get any DMA channel when you ask for one. Why
not do the same for DCA? There could be some generic DCA layer that can
be built all the time and returns DCA resources only if IOATDMA is
loaded/built ?

Brice

