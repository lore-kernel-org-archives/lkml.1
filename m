Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbXJRGzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbXJRGzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXJRGy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:54:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:22520 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXJRGy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:54:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,293,1188802800"; 
   d="scan'208";a="300734215"
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1abqif5dp.fsf@ebiederm.dsl.xmission.com>
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
	 <m1abqif5dp.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Oct 2007 14:57:22 +0800
Message-Id: <1192690642.21509.33.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 18 Oct 2007 06:54:53.0482 (UTC) FILETIME=[C92768A0:01C81153]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 03:38 -0600, Eric W. Biederman wrote:
> Well there actually is no reason to copy the current data into the
> zero page.  We really should just leave it where it is until the
> kernel has managed to bootstrap it's basic services.

I think it is safer to copy boot parameters to kernel BSS segment.
Because the kernel bootstrap process may overwrite the original memory
area of boot parameters.

> As for the setup data can we please remove the pointers. And just
> require the that the data items be appended one after each other
> in memory.  Then we would just need a field where we could
> report an offset to the binary data from where we loaded the
> 16bit code/data.  We could even specify the end by requiring
> that we fill in setup_move_size or something of that nature.

In this solution, we should also avoid conflict between the boot data
and kernel early bootstrap process. I think copy these boot data to some
place safe may be better. Such as memory area after _end.

> Beyond that we should provide the bootloaders enough information to
> know which information the kernel will overwrite before it consults
> the e820 map and other indicators of what memory is free.

There are several memory areas used by kernel bootstrap before e820 map
is consulted. You can refer to bad_addr for details. So I think it may
be not a stable/simple prototype to provide this information to
bootloader.

Best Regards,
Huang Ying
