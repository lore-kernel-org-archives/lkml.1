Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXHWCr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXHWCr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXHWCrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:47:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbXHWCrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:47:16 -0400
Message-ID: <46CCF523.2090403@zytor.com>
Date: Wed, 22 Aug 2007 19:46:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: huang ying <huang.ying.caritas@gmail.com>, Andi Kleen <ak@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1187313920.28497.1.camel@caritas-dev.intel.com>	 <1187580031.27947.67.camel@caritas-dev.intel.com>	 <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>	 <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>	 <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>	 <20070822012216.GN32640@bingen.suse.de>	 <86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>	 <20070822111155.GP32640@bingen.suse.de>	 <851fc09e0708220723v5fcb2fc5n4993c6f859c28b83@mail.gmail.com>	 <46CC6420.2030506@zytor.com> <1187835680.3247.14.camel@caritas-dev.intel.com>
In-Reply-To: <1187835680.3247.14.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> My intention is that we have 3 possible schemes for kernel to use boot
> information.
> 

That's not an intention, it's an observation.

> 1. Use "linked list" only. Then if booted with old bootloader which uses
> "zero page" protocol, the "zero page" information provided by bootloader
> should be converted to "linked list" for other part of kernel to use.
> 
> 2. Use "zero page" only. Then if booted with new bootloader which
> provides "linked list" but not "zero page", the "linked list"
> information provided by bootloader should be converted to "zero page"
> for other part of kernel to use.
> 
> 3. Use "zero page" + "linked list". Then if booted with old bootloader,
> the "linked list" is empty. If booted with new bootloader, both the
> "zero page" and "linked list" are used.
> 
> We need to choose one from schemes above.
> 
> - The scheme 1 appears the most clean one.
> - The scheme 2 has 4k "zero page" constraint, so it is not good.
> - The scheme 3 is easiest to be implemented.
> 
> Personally, I prefer the scheme 1. But the scheme 3 is OK too.

Scheme 3 is the only realistic way to move away from the current
situation (scheme 2).  Scheme 1 just means unnecessary divergences
between codepaths.  If it wasn't for LunacyBIOS and (to a smaller
extent) kexec, we would probably be OK, but that's not the real world.

	-hpa

