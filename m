Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYAHBfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYAHBfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYAHBfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:35:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:48287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYAHBfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:35:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,255,1196668800"; 
   d="scan'208";a="250848910"
Subject: Re: [RFC] PCIE ASPM support
From: Shaohua Li <shaohua.li@intel.com>
To: michael@ellerman.id.au
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1199743355.7518.2.camel@concordia>
References: <1199340944.1642.26.camel@sli10-desk.sh.intel.com>
	 <1199743355.7518.2.camel@concordia>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 09:35:42 +0800
Message-Id: <1199756142.28410.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 09:02 +1100, Michael Ellerman wrote:
> On Thu, 2008-01-03 at 14:15 +0800, Shaohua Li wrote:
> > PCI Express ASPM defines a protocol for PCI Express components in the D0
> > state to reduce Link power by placing their Links into a low power state
> > and instructing the other end of the Link to do likewise. This
> > capability allows hardware-autonomous, dynamic Link power reduction
> > beyond what is achievable by software-only controlled power management.
> > However, The device should be configured by software appropriately.
> > Enabling ASPM will save power, but will introduce device latency.
> > 
> > This patch adds ASPM support in Linux. It introduces a global policy for
> > ASPM, a sysfs file /sys/module/pcie_aspm/parameters/policy can control
> > it. The interface can be used as a boot option too. Currently we have
> > below setting:
> > 	-default, BIOS default setting
> > 	-powersave, highest power saving mode, enable all available ASPM state
> > and clock power management
> > 	-performance, highest performance, disable ASPM and clock power
> > management
> > By default, the 'default' policy is used currently.
> > 
> > In my test, power difference between powersave mode and performance mode
> > is about 1.3w in a system with 3 PCIE links.
> > 
> > please review, any comments will be appreciated.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> Minor nit, but you do a lot of these:
> 
> +	return ((struct link_state *)pdev->link_state)->bios_aspm_state;
> +	return ((struct link_state *)pdev->link_state)->bios_clk_state;
> +	((struct link_state*)pdev->link_state)->clk_pm_enabled = !!enable;
> +	((struct link_state*)pdev->link_state)->clk_pm_capable = capable;
> +	((struct link_state*)pdev->link_state)->clk_pm_enabled = enabled;
> +	((struct link_state*)pdev->link_state)->bios_clk_state = enabled;
> +	((struct link_state *)pdev->link_state)->enabled_state = state;
> +	if (((struct link_state *)pdev->link_state)->support_state == 0)
> +	if (((struct link_state *)pdev->link_state)->enabled_state == state)
> +	((struct link_state *)pdev->link_state)->enabled_state);
Thanks for your time. I'll fix in next release.

Thanks,
Shaohua

