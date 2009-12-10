Return-Path: <linux-kernel-owner+w=401wt.eu-S934170AbZLJLtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170AbZLJLtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934079AbZLJLtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:49:46 -0500
Received: from stinky.trash.net ([213.144.137.162]:36357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934019AbZLJLtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:49:45 -0500
Message-ID: <4B20E05C.1010604@trash.net>
Date: Thu, 10 Dec 2009 12:49:48 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: kxie@chelsio.com
CC: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
       netdev@vger.kernel.org, davem@davemloft.net, rakesh@chelsio.com,
       James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cxgb3i: Fix a login over vlan issue
References: <200912100535.nBA5ZM0L000413@localhost.localdomain>
In-Reply-To: <200912100535.nBA5ZM0L000413@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kxie@chelsio.com wrote:
> [PATCH 1/1] cxgb3i: Fix a login over vlan issue
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> Fix a login over vlan issue, when parent interface is vlan and we are using
> 
> cxgb3i sepecific private ip address in '/etc/iscsi/ifaces/' iface file.
> 
> +/**
> + * cxgb3i_find_dev - find the interface associated with the given address
> + * @ipaddr: ip address
> + */
> +static struct net_device *cxgb3i_find_dev(__be32 ipaddr)
> +{
> +	struct flowi fl;
> +	int err;
> +	struct rtable *rt;
> +
> +	memset(&fl, 0, sizeof(fl));
> +	fl.nl_u.ip4_u.daddr = ipaddr;
> +
> +	err = ip_route_output_key(&init_net, &rt, &fl);
> +	if (!err)
> +		return (&rt->u.dst)->dev;
> +
> +	return NULL;
> +}

This probably shouldn't be using init_net but the current namespace.
