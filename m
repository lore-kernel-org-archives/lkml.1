Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbYJMS2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbYJMS2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYJMS2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:28:40 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:2030 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753225AbYJMS2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:28:39 -0400
Message-ID: <48F391B9.1000206@myri.com>
Date: Mon, 13 Oct 2008 20:21:45 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: Adrian Bunk <bunk@kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: [BUILD_FAILURE] 2.6.27-git2 - allyesconfig on powerpc selectsCONFIG_INTEL_IOATDMA=y
References: <20081013101559.GA14372@linux.vnet.ibm.com> <20081013112631.GD29938@cs181140183.pp.htv.fi> <36D9DB17C6DE9E40B059440DB8D95F52066E2EAE@orsmsx418.amr.corp.intel.com>
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F52066E2EAE@orsmsx418.amr.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brandeburg, Jesse wrote:
> What we want, is myri10ge and ixgbe drivers that can build whether or not CONFIG_INTEL_IOATDMA is enabled.  IF CONFIG_INTEL_IOATDMA *is* enabled (which it should not be on PPC) then there are several cases we want to work:
> CONFIG_INTEL_IOATDMA=m  ---> CONFIG_IXGBE=[m|n]
> CONFIG_INTEL_IOATDMA=y  ---> CONFIG_IXGBE=[m|y|n]
> CONFIG_INTEL_IOATDMA=n  ---> CONFIG_IXGBE=[m|y|n]
> CONFIG_INTEL_IOATDMA depends on X86
>   

I am not sure I want to prevent myri10ge=y just because ioatdma=m.

I would vote for adding some Kconfig stuff to define CONFIG_MYRI10GE_DCA
as boolean set to yes if (IOATDMA=y and MYRI10GE=y/m) or (IOATDMA=m and
MYRI10GE=m). And then use #ifdef CONFIG_MYRI10GE_DCA in the driver source.

Brice

