Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbYBMNMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbYBMNMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYBMNMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:12:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:52782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbYBMNMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:12:35 -0500
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-Id: <D846801F-AA6B-4238-9FA4-A712EABFE800@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080213.004120.22092044.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [GIT]: Make LMB code sharable with sparc64.
Date: Wed, 13 Feb 2008 07:12:26 -0600
References: <20080213.004120.22092044.davem@davemloft.net>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 13, 2008, at 2:41 AM, David Miller wrote:

>
> As I mentioned to a few ppc folks at LCA08 I plan to use
> the LMB code from powerpc as a basis for NUMA support on
> sparc64.
>
> There are two changes.
>
> 1) Move arch/powerpc/mm/lmb.c to lib/lmb.c, put the main
>   interface bits in include/linux/lmb.h, put arch-specific
>   bits in asm/lmb.h and add Kconfig machinery to build this
>   stuff on sparc64.
>
> 2) Fix a bug in lmb_alloc() wherein the size was not aligned
>   so we could easily run out of reserve blocks because
>   every aligned allocation would create a tiny hole, and
>   secondly the lmb_reserve() call there did not have it's
>   return value checked.
>
> Powerpc folks, if there are no objections please pull, thanks!
>
> The following changes since commit  
> 96b5a46e2a72dc1829370c87053e0cd558d58bc0:
>  Linus Torvalds (1):
>        WMI: initialize wmi_blocks.list even if ACPI is disabled
>
> are available in the git repository at:
>
>  master.kernel.org:/pub/scm/linux/kernel/git/davem/lmb-2.6.git master
>
> David S. Miller (2):
>      [LIB]: Make PowerPC LMB code generic so sparc64 can use it too.
>      [LMB]: Fix bug in __lmb_alloc_base().

Does sparc have the concept of a phys_addr_t?  We are in the process  
of expanding the lmb support to deal with 36-bit physical addresses on  
32-bit machines.

- k
