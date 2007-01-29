Return-Path: <linux-kernel-owner+w=401wt.eu-S964894AbXA2X3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894AbXA2X3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964928AbXA2X3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:29:19 -0500
Received: from ozlabs.org ([203.10.76.45]:41606 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964894AbXA2X3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:29:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17854.33603.655565.110084@cargo.ozlabs.ibm.com>
Date: Tue, 30 Jan 2007 10:29:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: michael@ellerman.id.au
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, tony.luck@intel.com,
       grundler@parisc-linux.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz,
       brice@myri.com, greg@kroah.com, shaohua.li@intel.com, mingo@elte.hu,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
In-Reply-To: <1170065487.19887.91.camel@concordia.ozlabs.ibm.com>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	<20070128.153707.30184351.davem@davemloft.net>
	<m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	<20070128.212554.23015561.davem@davemloft.net>
	<1170050737.26655.233.camel@localhost.localdomain>
	<m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
	<1170065487.19887.91.camel@concordia.ozlabs.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman writes:

> You can read config space, but it's not clear to me if the HV is allowed
> to filter it and hide things. It's also possible that the device

It appears that the HV does not prevent us from reading or writing any
config space registers for functions that are assigned to us.

> supports MSI, but for some reason the HV doesn't allow it on that device
> etc. so you really have to ask the HV if it's enabled. So pci_find_cap()
> shouldn't crash or anything, but it may lie to you.

It's possible that the device can do MSI(X), but that using MSI(X)
requires other platform resources (e.g. interrupt source numbers) and
there are none free.  I believe the platform guarantees a minimum
number of MSI(X) interrupts per function, but a pci_enable_msix() call
may not be able to give the driver as many MSI-X interrupts as it is
requesting even if the function can handle that many.

Paul.
