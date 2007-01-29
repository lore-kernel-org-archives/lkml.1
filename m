Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXA2Ud0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXA2Ud0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXA2Ud0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:33:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:42805 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbXA2UdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:33:25 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <1170065487.19887.91.camel@concordia.ozlabs.ibm.com>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	 <20070128.153707.30184351.davem@davemloft.net>
	 <m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	 <20070128.212554.23015561.davem@davemloft.net>
	 <1170050737.26655.233.camel@localhost.localdomain>
	 <m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
	 <1170065487.19887.91.camel@concordia.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 07:32:10 +1100
Message-Id: <1170102731.26655.277.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> You can read config space, but it's not clear to me if the HV is allowed
> to filter it and hide things. 

I've seen it do it for example with EADS bridges. I haven't seen doing
it with devices (other than hiding entire functions) but I wouldn't
exclude it...

> It's also possible that the device
> supports MSI, but for some reason the HV doesn't allow it on that device
> etc. so you really have to ask the HV if it's enabled. So pci_find_cap()
> shouldn't crash or anything, but it may lie to you.

Yup.

> One thing I did like about my code, is that pci_enable_msi() and
> pci_enable_msix() are just small wrappers around generic_enable_msi() -
> which does all the work, and is the same regardless of whether it's an
> MSI or MSI-X. Although that's facilitated by the type arg which you
> don't like.

Part of the reason is you make MSI look like MSI-X (a vector of 1 entry)
while Eric does the opposite.

Ben.


