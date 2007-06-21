Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbXFUJZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbXFUJZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXFUJYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 05:24:47 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39355 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbXFUJYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 05:24:44 -0400
Message-ID: <467A43B1.3010308@bx.jp.nec.com>
Date: Thu, 21 Jun 2007 18:24:01 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take5 6/7] add ioctls for adding/removing target
References: <466FC455.5060001@bx.jp.nec.com> <466FC76A.6050006@bx.jp.nec.com>	 <a781481a0706131341k17170514q7a9d0ce052dbfe2a@mail.gmail.com>	 <4677AA3D.7010604@bx.jp.nec.com> <a781481a0706190809n3387caefv86d289cfd959f805@mail.gmail.com>
In-Reply-To: <a781481a0706190809n3387caefv86d289cfd959f805@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Satyam,

> Hmm, I might've missed this thread, but my opinion on the
> alternatives, fwiw:
> 
> 1. I think adding new ioctl's to the kernel are generally disliked for
> obvious reasons. Perhaps Stephen meant to add some generic
> ioctl's above (and not separate ones specially implemented for
> the dynamically reconfigurable netconsole driver)?

You're right.
At first, I implemented ioctls to misc device because of using misc sysfs.
But, Andrew Morton said "Using an ioctl() against a miscdev is rather 
untypical for networking.". So, I implemented ioclts to tty_driver.

> Please do consider configfs. Note that we'll have to lose the sysfs
> symlink from your target's kobject to the kobject of the ethernet
> device if we switch to configfs, but was that symlink needed for
> some essential functionality or was it simply for informational
> purpose? IMHO, this patchset only needs to bring in functionality
> to be able to create, destroy, and modify netconsole targets at
> run-time, and all these reconfiguration tasks would be handled
> quite well by configfs, AFAICT.

It was for informational pupose. But, if we used symlink to the net_device 
kobject in sysfs, we could easily keep up with changing network device name by 
changing symbolic link.
In the case of configfs, Do we use config_item related to the network interface 
because the configfs doesn't have symlink that refers to net_device kobject
(e.g. "network_interface" in configfs, "network_interface" value is "eth0")?

I'm going to search configfs and modify interface to configfs.

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com

