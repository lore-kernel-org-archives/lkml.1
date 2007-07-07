Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbXGGShh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbXGGShh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXGGSg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:36:56 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40277 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXGGSgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:36:53 -0400
Message-ID: <468FDC8D.6080208@bx.jp.nec.com>
Date: Sun, 08 Jul 2007 03:33:49 +0900
From: KII Keiichi <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 7/9] netconsole: Support multiple logging targets
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110814.28520.94417.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110814.28520.94417.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

The following comments aren't essential.

>  	if (!(event == NETDEV_UP || event == NETDEV_DOWN ||
>  	      event == NETDEV_CHANGEADDR || event == NETDEV_CHANGENAME))
> -	      	goto done;
> +		goto done;

The above diff lines are extra.

> +	spin_lock_irqsave(&target_list_lock, flags);
> +	list_for_each_entry(nt, &target_list, list) {
> +		if (nt->np.dev == dev) {
> +			switch (event) {
> +			case NETDEV_UP:
> +			case NETDEV_DOWN:
> +				nt->dev_status = net_dev_is_up(nt->np.dev);
> +				break;
> +
> +			case NETDEV_CHANGEADDR:
> +				memcpy(nt->np.local_mac, dev->dev_addr, ETH_ALEN);

The above line is over 80 characters.

Thanks,
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com



