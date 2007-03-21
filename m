Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXCULoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXCULoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXCULoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:44:37 -0400
Received: from ozlabs.org ([203.10.76.45]:50987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXCULog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:44:36 -0400
Subject: Re: [PATCH] Allow per-cpu variables to be page-aligned
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <m1ejnjc5qa.fsf@ebiederm.dsl.xmission.com>
References: <1174457426.11680.132.camel@localhost.localdomain>
	 <m1ejnjc5qa.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 22:44:16 +1100
Message-Id: <1174477457.11680.170.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 03:21 -0600, Eric W. Biederman wrote:
> Do we really want to allow modules to be able to allocate page sized
> per cpu memory.

Hi Eric!

	They always could, of course, they just wouldn't get correct alignment.
I think the principle of least surprise says that if we support this, it
will also work in modules...

>   If my memory servers on how this code works we will wind
> up allocating 1 page of per cpu memory for every module that allocates a
> per cpu variable.  128 bytes sucks 4k is an order of magnitude worse.

Not quite.  We allocate a total amount of per-cpu memory at boot, then
anything left over gets used for per-cpu vars in modules.

Looking at the module per-cpu code again, the rounding up of the memory
used by the kernel seems unnecessary though.  I'll try ripping that
out...

> On x86_64 we are only reserving 8K for modules...

Really?  I can't see that.

It did look like the x86-64 setup_per_cpu_areas should be moved into
common code though (it's numa-aware).  Maybe that breaks some platforms.

It means the x86 cpu_pda initialization would have to be done in
smp_prepare_boot_cpu tho...

Cheers!
Rusty.


