Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbXFSKFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbXFSKFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbXFSKFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:05:11 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51514 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbXFSKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:05:08 -0400
Message-ID: <4677AA3D.7010604@bx.jp.nec.com>
Date: Tue, 19 Jun 2007 19:04:45 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take5 6/7] add ioctls for adding/removing target
References: <466FC455.5060001@bx.jp.nec.com> <466FC76A.6050006@bx.jp.nec.com> <a781481a0706131341k17170514q7a9d0ce052dbfe2a@mail.gmail.com>
In-Reply-To: <a781481a0706131341k17170514q7a9d0ce052dbfe2a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Satyam,

> *ugh*. I was wondering what a show-stopper this particular patch
> was -- introduces a couple of ioctl()'s, exports a new structure to
> userspace, adds a hitherto-unneeded header file, brings in
> tty_struct/tty_operations and ends up adding so much complexity/
> bloat to netconsole.c. Not only that, it must live together (and
> side-by-side) with the sysfs interface also, because the two of them
> do different things: sysfs to be able to modify target parameters at
> run-time and the ioctl()'s to dynamically add/remove targets. We
> can't really mkdir(2) or rmdir(2) in sysfs so the ioctl()'s are needed.
> 
> So may I suggest:
> 
> Just lose *both* the sysfs and ioctl() interfaces and use _configfs_.
> It is *precisely* the thing you need in your driver here -- the ability
> to create / destroy kernel objects (or config_items in configfs lingo)
> from _userspace_ via simple mkdir(2) and rmdir(2). And configfs
> makes changing multiple configurable parameters atomically trivial
> too, via rename(2) ... not to mention a sysfs+ioctls -> configfs
> conversion would help your patchset lose some weight too :-)

Stephen Hemminger previously advised me	about the user interface such as 
the following messages.

> Some other speculations:
> 1. Would it be possible to add ioctl's to /dev/console? This would be more in
>     keeping with older Unix style model.
> 
> 2. Using sysfs makes sense if there is a device object that exists to
>    add the sysfs attributes to.
> 
> 3. Procfs is handy for summary type tables.
> 
> 4. Netlink does feel like overkill for this. Although newer generic netlink
>    makes it easier.

So, I implemented ioctls to add/remove port like this patch on the tty driver.
But I'm going to search configfs. Thank you for you information.

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com

