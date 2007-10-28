Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXJ1WuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXJ1WuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXJ1WuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:50:06 -0400
Received: from tim.rpsys.net ([194.106.48.114]:49477 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbXJ1WuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:50:04 -0400
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to
	kernel
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>, svs1957@gmail.com
Cc: bgat@billgatliff.com, linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk,
       bugme-daemon@bugzilla.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1193349292.17244.1.camel@localhost.localdomain>
References: <bug-9217-10286@http.bugzilla.kernel.org/>
	 <20071024195717.0de6a248.akpm@linux-foundation.org>
	 <47200F05.2050305@billgatliff.com>
	 <20071025122303.GB7543@xi.wantstofly.org>
	 <1193319816.6167.45.camel@localhost.localdomain>
	 <20071025130250.cd759e90.akpm@linux-foundation.org>
	 <1193349292.17244.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 22:46:47 +0000
Message-Id: <1193611607.7401.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 22:54 +0100, Richard Purdie wrote:
> On Thu, 2007-10-25 at 13:02 -0700, Andrew Morton wrote:
> > It was in the inital report, at
> > http://bugzilla.kernel.org/show_bug.cgi?id=9217 :
>
> This is the commandline they wanted to use, not the one that was
> actually used. The one that was used should appear on the console, on
> the serial console if they have the lead or in dmesg when the device
> boots. We know it probably contained root=/dev/mtdblock2 but thats it.
> 
> I'd like to confirm which commandline is appearing since if we know
> which one it is we might stand a chance of knowing where it came from,
> until then this is just a guessing game.

There was a followup in the bugzilla:

> I use u-boot to boot kernel.
> When kernel >=2.6.23 boot it use u-boot default bootparam:
> console=ttyS0,115200 console=tty1 root=/dev/mtdblock2 rootfstype=jffs2
> Now I try to change it in u-boot source.
>
> kernel 2.6.22.9 change default u-boot boot params to what I set in
> CONFIG_CMDLINE But 2.6.23 and later doesn't

So its not the standard bootloader, its one which passes an ATAG
commandline and 2.6.23 onwards uses an ATAG commandline if present over
the compiled in commandline.

My opinion is that this is a feature. Recompile the bootloader without
the commandline if you want to use the one compiled into the kernel.

This is going to be useful in the future when booting Zaurus kernels
with kexec since it means we can customise the commandline through the
ATAGs.

Cheers,

Richard

