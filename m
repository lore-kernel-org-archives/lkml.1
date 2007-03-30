Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXC3OUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXC3OUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXC3OUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:20:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:50331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbXC3OUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:20:36 -0400
Date: Fri, 30 Mar 2007 07:18:56 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] fixed_init(): BUG: at drivers/base/core.c:120
	device_release(), was: "2.6.21-rc5: known regressions"
Message-ID: <20070330141856.GB10387@suse.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu> <20070330120657.GA21271@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330120657.GA21271@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 02:06:57PM +0200, Ingo Molnar wrote:
> 
> there's a new type of message in allyesconfig-bzImage bootup test:
> 
> Calling initcall 0xc1b6d692: fixed_init+0x0/0x33()
> Fixed PHY: Registered new driver
> Device 'fixed@100:1' does not have a release() function, it is broken and must be fixed.
> BUG: at drivers/base/core.c:120 device_release()
>  [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
>  [<c01063e2>] show_trace+0x12/0x14
>  [<c01063f8>] dump_stack+0x14/0x16
>  [<c063cddf>] device_release+0x7c/0x7e
>  [<c0476c32>] kobject_cleanup+0x44/0x5e
>  [<c0476c57>] kobject_release+0xb/0xd
>  [<c04773ef>] kref_put+0x63/0x71
>  [<c0476757>] kobject_put+0x14/0x16
>  [<c063ceef>] put_device+0x11/0x13
>  [<c063d943>] device_unregister+0x12/0x15
>  [<c07337d1>] fixed_mdio_register_device+0x210/0x23b
>  [<c1b6d6b0>] fixed_init+0x1e/0x33
>  [<c1b31a2d>] init+0x15d/0x2bd
>  [<c0105bc3>] kernel_thread_helper+0x7/0x10
>  =======================
> Device 'fixed@10:1' does not have a release() function, it is broken and must be fixed.
> BUG: at drivers/base/core.c:120 device_release()
>  [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
>  [<c01063e2>] show_trace+0x12/0x14
>  [<c01063f8>] dump_stack+0x14/0x16
>  [<c063cddf>] device_release+0x7c/0x7e
>  [<c0476c32>] kobject_cleanup+0x44/0x5e
>  [<c0476c57>] kobject_release+0xb/0xd
>  [<c04773ef>] kref_put+0x63/0x71
>  [<c0476757>] kobject_put+0x14/0x16
>  [<c063ceef>] put_device+0x11/0x13
>  [<c063d943>] device_unregister+0x12/0x15
>  [<c07337d1>] fixed_mdio_register_device+0x210/0x23b
>  [<c1b6d6c1>] fixed_init+0x2f/0x33
>  [<c1b31a2d>] init+0x15d/0x2bd
>  [<c0105bc3>] kernel_thread_helper+0x7/0x10

That means that whatever driver has fixed_mdio_register_device() in it
is broken and needs to be fixed.

It is independant from your previous question about unregistering the
device from within module_init().

thanks,

greg k-h
