Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYIWXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYIWXa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYIWXaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:30:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60128
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbYIWXaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:30:09 -0400
Date: Tue, 23 Sep 2008 16:29:57 -0700 (PDT)
Message-Id: <20080923.162957.141669474.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: jeff@garzik.org, mingo@elte.hu, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       john.ronciak@intel.com, bruce.w.allan@intel.com
Subject: Re: [PATCH 2/3] e1000e: Useset_memory_ro()/set_memory_rw() to
 protect flash memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080923224535.6869.76210.stgit@jtkirshe-mobile.jf.intel.com>
References: <20080923224535.6869.76210.stgit@jtkirshe-mobile.jf.intel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 23 Sep 2008 15:45:54 -0700

> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> A number of users have reported NVM corruption on various ICHx platform
> LOMs.  One possible reasons for this could be unexpected and/or malicious
> writes to the flash memory area mapped into kernel memory.  Once the
> interface is up, there should be very few reads/writes of the mapped flash
> memory.  This patch makes use of the x86 set_memory_*() functions to set
> the mapped memory read-only and temporarily set it writable only when the
> driver needs to write to it.  With the memory set read-only, any unexpected
> write will be logged with a stack dump indicating the offending code.
> 
> Since these LOMs are only on x86 ICHx platforms, it does not matter that
> this API is not yet available on other architectures, however it is
> dependent on a previous patch that exports these function name symbols.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

If the X server or similar is causing this problem, this patch won't help.

The X server maps MMIO space using mmap() in userspace, and you're only
protecting the kernel side mapping.
