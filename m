Return-Path: <linux-kernel-owner+w=401wt.eu-S964777AbXA2XlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777AbXA2XlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXA2XlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:41:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:60602 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964777AbXA2XlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:41:19 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
Cc: michael@ellerman.id.au, tony.luck@intel.com, grundler@parisc-linux.org,
       jeff@garzik.org, David Miller <davem@davemloft.net>, greg@kroah.com,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz, mingo@elte.hu,
       brice@myri.com
In-Reply-To: <17854.33603.655565.110084@cargo.ozlabs.ibm.com>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	 <20070128.153707.30184351.davem@davemloft.net>
	 <m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	 <20070128.212554.23015561.davem@davemloft.net>
	 <1170050737.26655.233.camel@localhost.localdomain>
	 <m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
	 <1170065487.19887.91.camel@concordia.ozlabs.ibm.com>
	 <17854.33603.655565.110084@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 10:40:03 +1100
Message-Id: <1170114003.26655.291.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It's possible that the device can do MSI(X), but that using MSI(X)
> requires other platform resources (e.g. interrupt source numbers) and
> there are none free.  I believe the platform guarantees a minimum
> number of MSI(X) interrupts per function, but a pci_enable_msix() call
> may not be able to give the driver as many MSI-X interrupts as it is
> requesting even if the function can handle that many.

However, the ibm,req#msi(-x) properties contain the number as requested
by the device, and thus I expect them to be identical to the config
space value. So if you are confident enough that our HV won't play any
tricks there in the future, reading the config space is as good as
hooking that check() callback, though it might not be vs. some other HV
for some other platform that might be more strict.

We cannot know in advance how much max the HV will give us without
actually trying ibm,change-msi and see the result code for it
unfortunately.

Ben.


