Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbXHWCVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbXHWCVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbXHWCUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:20:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:41250 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbXHWCUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,297,1183359600"; 
   d="scan'208";a="286695841"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: huang ying <huang.ying.caritas@gmail.com>, Andi Kleen <ak@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
In-Reply-To: <46CC6420.2030506@zytor.com>
References: <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <1187580031.27947.67.camel@caritas-dev.intel.com>
	 <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>
	 <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>
	 <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
	 <20070822012216.GN32640@bingen.suse.de>
	 <86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>
	 <20070822111155.GP32640@bingen.suse.de>
	 <851fc09e0708220723v5fcb2fc5n4993c6f859c28b83@mail.gmail.com>
	 <46CC6420.2030506@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Aug 2007 10:21:20 +0800
Message-Id: <1187835680.3247.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 23 Aug 2007 02:20:36.0078 (UTC) FILETIME=[30A4D8E0:01C7E52C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 00:28 +0800, H. Peter Anvin wrote:
> huang ying wrote:
> >
> > My proposal: Use Peter proposed "linked list of struct setup_data"
> > style boot protocol as long term goal.
> >
> > To smooth the transforming process, the following back compatible
> > scheme can be taken:
> >
> > 1. Keep zero page as an informal external boot protocol, and marked
> it
> > as deprecated for external usage.
> > 2. Add a magic number to standard boot protocol, which is set by
> > bootloader to indicate the new style or old style boot protocol is
> > used.
> > 3. Add the pointer to "linked list of struct setup_data" to standard
> > boot protocol.
> > 4. If kernel is booted with correct magic number, the kernel will
> > convert "linked list" to zero page, or use "linked list" directly.
> If
> > kernel is booted with incorrect magic number, the kernel will use
> the
> > "zero page" from bootloader or convert "zero page" to "linked list".
> >
> You're making it needlessly complicated.

My intention is that we have 3 possible schemes for kernel to use boot
information.

1. Use "linked list" only. Then if booted with old bootloader which uses
"zero page" protocol, the "zero page" information provided by bootloader
should be converted to "linked list" for other part of kernel to use.

2. Use "zero page" only. Then if booted with new bootloader which
provides "linked list" but not "zero page", the "linked list"
information provided by bootloader should be converted to "zero page"
for other part of kernel to use.

3. Use "zero page" + "linked list". Then if booted with old bootloader,
the "linked list" is empty. If booted with new bootloader, both the
"zero page" and "linked list" are used.

We need to choose one from schemes above.

- The scheme 1 appears the most clean one.
- The scheme 2 has 4k "zero page" constraint, so it is not good.
- The scheme 3 is easiest to be implemented.

Personally, I prefer the scheme 1. But the scheme 3 is OK too.

Best Regards,
Huang Ying
