Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbYD3E2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbYD3E2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 00:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYD3E2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 00:28:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37385
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbYD3E2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 00:28:34 -0400
Date: Tue, 29 Apr 2008 21:28:33 -0700 (PDT)
Message-Id: <20080429.212833.192304794.davem@davemloft.net>
To: venkatesh.pallipadi@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem gcc weak function workaround
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430013108.GA18207@linux-os.sc.intel.com>
References: <20080430013108.GA18207@linux-os.sc.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date: Tue, 29 Apr 2008 18:31:09 -0700

> Some flavors of gcc 4.1.0 and 4.1.1 seems to have trouble understanding
> weak function definitions. Calls to function from the same file where it is
> defined as weak _may_ get inlined, even when there is a non-weak definition of
> the function elsewhere. I tried using attribute 'noinline' which does not
> seem to help either.
> 
> One workaround for this is to have weak functions defined in different
> file as below. Other possible way is to not use weak functions and go back
> to ifdef logic.
> 
> There are few other usages in kernel that seem to depend on weak (and noinline)
> working correctly, which can also potentially break and needs such workarounds.
> Example -
> mach_reboot_fixups() in arch/x86/kernel/reboot.c is one such call which
> is getting inlined with a flavor of gcc 4.1.1.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

This sounds like a bug.  And if gcc does multi-file compilation it
can in theory do the same mistake even if you move it to another
file.

We need something more bulletproof here.

Also, we have a macro for marking things weak "__weak" which should
be used here.
