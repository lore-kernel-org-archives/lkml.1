Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbXA2U13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbXA2U13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXA2U12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:27:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:43384 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXA2U12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:27:28 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	 <20070128.153707.30184351.davem@davemloft.net>
	 <m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	 <20070128.212554.23015561.davem@davemloft.net>
	 <1170050737.26655.233.camel@localhost.localdomain>
	 <m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 07:22:38 +1100
Message-Id: <1170102158.26655.273.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This is the most straight forward and handles machines with really
> weird msi setups, so I lean in this direction.
> 
> The question is there anything at all we can do generically?
> 
> I can't see a case where ppc_md would not wind up with the hooks
> that decide if it is a hypervisor or not.  Even if we came up
> with a better set of functions you need to hook.

Sure, but with Michael's approach, the only hook was get_msi_ops(pdev) 

Anyway, there isn't -that- much that can be done generically in the HV
case. Mostly some argument sanity checking, the logic for saving &
restoring pdev->irq for MSIs, that sort of thing.

> Ok. I think I get the point of check.  I believe I need to look at your
> code a little more and see what you are doing to see if there is anything
> generic worth doing, that we can always do outside of architecture code
> no matter how much of the job the Hypervisor wants to do for us.

I understand.

> I'd hate to hit a different Hypervisor that did something close but
> not quite the same and have the code fail then.  So definitely
> avoiding touching pci config space at all in the calls seems to make a
> lot of sense.  This includes avoiding pci_find_capability right?

Quite possibly yes. I'm pretty sure it will work on IBM HV but we aren't
really supposed to use it...

> Off the top of my head the only things we can do generically are
> some data structure things and flags like dev->msi_enabled or
> dev->msix_enabled.

That and the saving & restoring of pdev->irq. That is not very much.

> Anyway have a nice night and more in the morning.

Ben.

