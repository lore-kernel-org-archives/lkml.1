Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYADBb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYADBb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYADBbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:31:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:6191 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbYADBbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:31:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,241,1196668800"; 
   d="scan'208";a="313801625"
Subject: Re: [RFC] PCIE ASPM support
From: Shaohua Li <shaohua.li@intel.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <477D3889.9070301@intel.com>
References: <1199340944.1642.26.camel@sli10-desk.sh.intel.com>
	 <477D3889.9070301@intel.com>
Content-Type: text/plain
Date: Fri, 04 Jan 2008 09:32:04 +0800
Message-Id: <1199410324.3631.7.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 11:33 -0800, Kok, Auke wrote:
> Shaohua Li wrote:
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
> 
> 
> quickly glanced this over since I recently disabled l1 ASPM for the e1000/e1000e
> driven 82573 device which has issues with l1 ASPM. that immediately gives me the
> question: how can I continue to disable 1l aspm by default for this device using
> this infrastructure?
I used to have a per-device interface, but thought the interface might
be hard to use for users. If we really need the per-device interface, I
can re-add it.

> I do like the fact that there is a generic way to re-enable it for the users who
> want to use it. Can this change be done when the device is already active?
Yes, at least in my test.

> Can you
> change this parameter per device/module?
Another way is to provide a helper for driver, and driver disables
specific ASPM states. It sounds better to let driver do the disabling,
as users haven't the knowledge?

Thanks,
Shaohua

