Return-Path: <linux-kernel-owner+w=401wt.eu-S936566AbXHHTre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936566AbXHHTre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbXHHTrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:47:25 -0400
Received: from ns.suse.de ([195.135.220.2]:56210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674AbXHHTrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:47:24 -0400
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "Mao, Bibo" <bibo.mao@intel.com>
Subject: Re: [PATCH 0/5] x86_64 EFI support -v3
References: <1185851569.23149.25.camel@caritas-dev.intel.com>
	<m1myxdtc19.fsf@ebiederm.dsl.xmission.com>
	<1186378838.3769.27.camel@caritas-dev.intel.com>
	<m1d4xyc6v2.fsf@ebiederm.dsl.xmission.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Aug 2007 22:41:43 +0200
In-Reply-To: <m1d4xyc6v2.fsf@ebiederm.dsl.xmission.com>
Message-ID: <p73y7glg3nc.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:
> 
> Since there are people actively investigating things like booting
> OpenBSD via kexec things get even worse. Nothing hardly runs
> on ia64 so that issue doesn't come up.

If you want to do a popularity contest I expect there are far more ia64 
linux users than kexec-of-openbsd users.

> As for not using EFI at all.  If we can avoid it/not use it in the
> dump kernel there is very little point in having it in the primary
> kernel.

One interesting area is to use it for saving oops data. But
that has to be simple. I'm not sure complicated context switches
are a good idea here. 

However I agree it probably doesn't make sense to do virtual
mode just for the clock services -- so far we seem to be fine
just talking to the hardware directly.

> So far there don't seem to be any compelling advantages to running
> EFI in virtual address mode and several compelling disadvantages
> included having to change the permissions on the kernels memory
> map to running EFI in virtual mode.

I don't think it's a big issue to have a few less NX bits. Just
the original patch for it was ugly.
 
> Please let's stick to a physical mode trampoline and only revisit
> the topic when users start having problems because of the performance
> hit of going through our trampoline to the EFI runtime services.

So you want to switch to new page tables when calling EFI services
after boot? 

Potential problems:
- Interrupts have to be disabled. Is that ok? 
- When EFI BIOS start crashing how do we set up exception handlers
for this? 

I guess it would get complex long term. Also doesn't really sound 
attractive.

-Andi
