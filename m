Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbXGGShu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbXGGShu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXGGSg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:36:59 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37555 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXGGSgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:36:55 -0400
Message-ID: <468FDC87.6050702@bx.jp.nec.com>
Date: Sun, 08 Jul 2007 03:33:43 +0900
From: KII Keiichi <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 4/9] netconsole: Introduce netconsole_netdev_notifier
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110759.28520.37301.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110759.28520.37301.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

> [4/9] netconsole: Introduce netconsole_netdev_notifier
> 
> To update fields of underlying netpoll structure at runtime on
> corresponding NETDEV_CHANGEADDR or NETDEV_CHANGENAME notifications.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> Cc: Takayoshi Kochi <t-kochi@bq.jp.nec.com>

Should we avoid the automatic update of netconsole_target until we can notice all 
necessary members of netconsole_target updated automatically?

I had thought about automatic updating of the netconsole_target(i.e. local IP address 
and network device).
But I thought that the netconsole(netpoll) can only be related to a network device
because the user of netconsole is free to be able to set local IP address and 
MAC address of netconsole and it is difficult to monitor change of local IP address.
So, my patches only updates the network device automatically by using a symbolic link 
to the network device in sysfs when the event of NETDEV_CHANGEADDR occurs. 
The symbolic link to the network device in sysfs has the same meaning as following change
of MAC address and hardware.
(but I hadn't known the changing ability of MAC address using ip(8) command, 
thanks for your info)

Or I propose updating netconsole_taget informations when the network device up/down.
The MAC address and network interface name can be changed when 
the network device is disabled.
But, in the case, we must think of the case of changing IP address 
because we can change IP address without disabling the network device and 
can't hook the event of changing IP address.

How do you think?

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com


