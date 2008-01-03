Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYACTeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYACTeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYACTeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:34:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:30932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYACTeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:34:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="248479847"
Message-ID: <477D3889.9070301@intel.com>
Date: Thu, 03 Jan 2008 11:33:29 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [RFC] PCIE ASPM support
References: <1199340944.1642.26.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1199340944.1642.26.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jan 2008 19:34:12.0304 (UTC) FILETIME=[9E22B500:01C84E3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> PCI Express ASPM defines a protocol for PCI Express components in the D0
> state to reduce Link power by placing their Links into a low power state
> and instructing the other end of the Link to do likewise. This
> capability allows hardware-autonomous, dynamic Link power reduction
> beyond what is achievable by software-only controlled power management.
> However, The device should be configured by software appropriately.
> Enabling ASPM will save power, but will introduce device latency.
> 
> This patch adds ASPM support in Linux. It introduces a global policy for
> ASPM, a sysfs file /sys/module/pcie_aspm/parameters/policy can control
> it. The interface can be used as a boot option too. Currently we have
> below setting:
> 	-default, BIOS default setting
> 	-powersave, highest power saving mode, enable all available ASPM state
> and clock power management
> 	-performance, highest performance, disable ASPM and clock power
> management
> By default, the 'default' policy is used currently.
> 
> In my test, power difference between powersave mode and performance mode
> is about 1.3w in a system with 3 PCIE links.
> 
> please review, any comments will be appreciated.


quickly glanced this over since I recently disabled l1 ASPM for the e1000/e1000e
driven 82573 device which has issues with l1 ASPM. that immediately gives me the
question: how can I continue to disable 1l aspm by default for this device using
this infrastructure?

I do like the fact that there is a generic way to re-enable it for the users who
want to use it. Can this change be done when the device is already active? Can you
change this parameter per device/module?

> +	/* Clock PM state*/
> +	unsigned int clk_pm_capable:1;
> +	unsigned int clk_pm_enabled:1;
> +	unsigned int bios_clk_state:1;

might want to get rid of these bitfields?

Cheers,

Auke
