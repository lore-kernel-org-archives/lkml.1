Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbXCZDI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbXCZDI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 23:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXCZDI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 23:08:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59066 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbXCZDIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 23:08:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 17/21] MSI: Clear the irq_desc's msi pointer on free
References: <20070322105344.A34C6DDF74@ozlabs.org>
	<m1slbx8ihm.fsf@ebiederm.dsl.xmission.com>
	<1174604508.5401.7.camel@concordia.ozlabs.ibm.com>
	<m1y7lo64v4.fsf@ebiederm.dsl.xmission.com>
	<1174877836.4782.6.camel@concordia.ozlabs.ibm.com>
Date: Sun, 25 Mar 2007 21:07:31 -0600
In-Reply-To: <1174877836.4782.6.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Mon, 26 Mar 2007 12:57:16 +1000")
Message-ID: <m1lkhk3dos.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> We don't call dynamic_irq_cleanup(), so it never gets done. Perhaps we
> should be using your dynamic_irq_init/cleanup.

It depends.  If you are going through another irq controller etc.
dynamic_irq_cleanup is probably excessive.

>> Therefore you are doing this too late and we need to ensure the
>> architecture code does this in arch_teardown_msi_irq.
>
> As long as the arch teardown routine somehow calls dynamic_irq_cleanup()
> it should be fine. But I guess it's probably safer to just have all
> archs do set_msi_irq(irq, NULL) in the teardown.

Yes.  That sounds correct.

Eric
