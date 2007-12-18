Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbXLREd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbXLREd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXLREdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:33:18 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60964 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXLREdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:33:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@muc.de>
Cc: Paul Mackerras <paulus@samba.org>, Greg KH <gregkh@suse.de>,
       David Miller <davem@davemloft.net>, venkatesh.pallipadi@intel.com,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
References: <20071213235543.568682000@intel.com>
	<20071213235712.813201000@intel.com> <20071214001932.GA10389@suse.de>
	<20071213.163505.14070110.davem@davemloft.net>
	<20071214063424.GB10100@suse.de>
	<18277.40798.828760.919571@cargo.ozlabs.ibm.com>
	<20071217124137.GA18648@muc.de>
Date: Mon, 17 Dec 2007 21:30:11 -0700
In-Reply-To: <20071217124137.GA18648@muc.de> (Andi Kleen's message of "17 Dec
	2007 13:41:37 +0100, Mon, 17 Dec 2007 13:41:37 +0100")
Message-ID: <m1ejdkd3qk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@muc.de> writes:

> On Mon, Dec 17, 2007 at 08:57:50AM +1100, Paul Mackerras wrote:
>> Greg KH writes:
>> 
>> > Ok, sorry, it wasn't blindingly obvious that this was for pci sysfs
>> > devices that are mmaped, that makes a bit more sense.
>> > 
>> > But I'd like to see what ioctl is wanted here first.
>> 
>> I believe the ioctl would be to set whether the mapping goes to I/O or
>> memory space, 
>
> x86 cannot really access IO space through mmap so no that wasn't planned

0000_00FD_FC00_0000h - 0000_00FD_FDFF_FFFFh On a hypertransport based
system should work.  There is a 32MB window for it.

However the I/O vs mem distinction doesn't matter anyway if we start out
per bar because we already know if it is I/O or mem.

> The main planned use was to get the translated bus address (after IOMMU)
> for a mapping and to set the caching modes.
>
>> So the alternative to the ioctl would be to have multiple files in
>> sysfs, one per combination of modes -- i.e., 4 files, or 3 if we
>> exclude the "I/O with write combining" mode, which would be
>> reasonable.
>
> At least for the IOMMU translation case that wouldn't work.

Well the other alternative looks like having a second file per par
bar.  Say resource0_wc to support the write-combining mode, possibly
restricted to just prefetchable bars.

If that is all we have to worry about my inclination is to suggest
a second file, because that feels a bit more generally useable.  As
that attribute could be applied to ordinary reads and writes to and
from the bar.

Eric
