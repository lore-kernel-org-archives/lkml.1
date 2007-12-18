Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXLRNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXLRNvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbXLRNvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:51:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46570 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbXLRNvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:51:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@muc.de>
Cc: Paul Mackerras <paulus@samba.org>, Greg KH <gregkh@suse.de>,
       David Miller <davem@davemloft.net>, venkatesh.pallipadi@intel.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
References: <20071213235543.568682000@intel.com>
	<20071213235712.813201000@intel.com> <20071214001932.GA10389@suse.de>
	<20071213.163505.14070110.davem@davemloft.net>
	<20071214063424.GB10100@suse.de>
	<18277.40798.828760.919571@cargo.ozlabs.ibm.com>
	<20071217124137.GA18648@muc.de>
	<m1ejdkd3qk.fsf@ebiederm.dsl.xmission.com>
	<20071218093553.GA20611@muc.de>
Date: Tue, 18 Dec 2007 06:48:45 -0700
In-Reply-To: <20071218093553.GA20611@muc.de> (Andi Kleen's message of "18 Dec
	2007 10:35:53 +0100, Tue, 18 Dec 2007 10:35:53 +0100")
Message-ID: <m1k5nc9kqq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@muc.de> writes:

>> Well the other alternative looks like having a second file per par
>> bar.  Say resource0_wc to support the write-combining mode, possibly
>
> The intention was to support memory not in bars, but give a generic
> IOMMU mapped memory interface for user space e.g. for the X server.
> But that needs a way to return the bus address for the mmap mapping
> and ioctl was the best I came up with for that.
> Given it was never finished.

Ok that part wasn't obvious.  The only thing we mmap in sysfs today
are the bars.

Taking normal memory and iommu mapping it to a device and then having
a user space accessible version is a bit different.  We need a special
interface to allocate it and map it through the iommu to user space.
This needs to be a driver or a support subsystem like DRM.  Once
we have gone that far then we can map those address to user space.

I expect from the sysfs perspective those per device regions should look
a lot like bars showing contiguous chunks of memory RAM from the devices
perspective.  At which point having two files instead of just one can
solve the problem without an ioctl.

For contiguous to device memory we also have some permission issues
so I'm not yet certain that it make sense to expose it through sysfs.

Regardless that seems to be solving a completely new aspect of the problem,
and we can solve that problem separately.

Eric


