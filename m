Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXC0DcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXC0DcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbXC0DcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:32:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45744 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933963AbXC0DcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:32:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Thomas Meyer" <thomas@m3y3r.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <617E1C2C70743745A92448908E030B2A0148323B@scsmsx411.amr.corp.intel.com>
Date: Mon, 26 Mar 2007 21:29:43 -0600
In-Reply-To: <617E1C2C70743745A92448908E030B2A0148323B@scsmsx411.amr.corp.intel.com>
	(Tony Luck's message of "Mon, 26 Mar 2007 13:01:05 -0700")
Message-ID: <m1r6rbz7mg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luck, Tony" <tony.luck@intel.com> writes:

>> What I'm proposing we do is move the irq allocation code out of
>> pci_enable_device and the irq freeing code out of pci_disable_device
>> in the future.
>
> Sounds rational ... in a world that wasn't dominated by PCI it would
> seem to be the logical approach (since the irq code would have much
> more utility independent of the PCI code).

Right.  We can even do this earlier in the pci code.  Just doing this
on demand when the device driver needs it is problematic.  As devices
drivers like to keep the requested over a pci_disable_device pci_enable_device
pair.

The big practical issue is that we will like wind up allocating an irq
number to all usable irqs on ia64.  Which means we will like need many
more irq numbers...  Although I guess if we keep it at the pci layer
we should be fairly safe.

I was afraid there was some hotplug reason for waiting until pci_enable_device
to allocate the irq numbers.

>> Tony, Len before we merge any fixes for 2.6.21-rcX I'd like to at
>> least get an ack on the long term direction.
>
> Long-term-direction-acked-by: Tony Luck <tony.luck@intel.com>

Thanks.  Then small surgery will happen now, and I will start queuing up
the major surgery patches.  Although I won't be able to do more than
compile test and code review the ia64 changes.

Eric
