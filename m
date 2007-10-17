Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbXJQJin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbXJQJin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXJQJig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:38:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39712 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbXJQJif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:38:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
Date: Wed, 17 Oct 2007 03:38:10 -0600
In-Reply-To: <1192168345.17539.42.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Fri, 12 Oct 2007 13:52:25 +0800")
Message-ID: <m1abqif5dp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> This patchset defines a 32-bit boot protocol for i386/x86_64 platform,
> adds an extensible boot parameter passing mechanism, export the boot
> parameters via sysfs.
>
> The patchset has been tested against 2.6.23-rc8-mm2 kernel on x86_64
> and i386.
>
> This patchset is based on the proposal of Peter Anvin.
>
>
> Known Issues:
>
> - Where is safe to place the linked list of setup_data?  Because the
>   length of the linked list of setup_data is variable, it can not be
>   copied into BSS segment of kernel as that of "zero page". We must
>   find a safe place for it, where it will not be overwritten by kernel
>   during booting up. The i386 kernel will overwrite some pages after
>   _end. The x86_64 kernel will overwrite some pages from 0x1000 on.

Well there actually is no reason to copy the current data into the
zero page.  We really should just leave it where it is until the
kernel has managed to bootstrap it's basic services.

As for the setup data can we please remove the pointers. And just
require the that the data items be appended one after each other
in memory.  Then we would just need a field where we could
report an offset to the binary data from where we loaded the
16bit code/data.  We could even specify the end by requiring
that we fill in setup_move_size or something of that nature.

Beyond that we should provide the bootloaders enough information to
know which information the kernel will overwrite before it consults
the e820 map and other indicators of what memory is free.

Eric
