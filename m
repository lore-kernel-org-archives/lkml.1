Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYL2WWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYL2WWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYL2WWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:22:04 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:55003 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYL2WWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:22:01 -0500
Message-ID: <49594D79.30806@oracle.com>
Date: Mon, 29 Dec 2008 14:21:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 29 (fcoe)
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>	 <20081229123115.9a255fa8.randy.dunlap@oracle.com>	 <1230586520.3302.61.camel@localhost.localdomain> <1230587141.3302.64.camel@localhost.localdomain>
In-Reply-To: <1230587141.3302.64.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49594D7D.01DC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> 
> Actually, I deduce the problem is owner->name and your build has
> CONFIG_MODULE=n ... the definition of struct module is enclosed in a
> #ifdef CONFIG_MODULE.
> 
> This should fix it.
> 
> James

Ack.  Thanks.

> ---
> 
> diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
> index 1cb549c..fec38f6 100644
> --- a/drivers/scsi/fcoe/libfcoe.c
> +++ b/drivers/scsi/fcoe/libfcoe.c
> @@ -992,7 +992,7 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
>  	owner = fcoe_netdev_to_module_owner(netdev);
>  	if (owner) {
>  		printk(KERN_DEBUG "foce:hold driver module %s for %s\n",
> -		       owner->name, netdev->name);
> +		       module_name(owner), netdev->name);
>  		return  try_module_get(owner);
>  	}
>  	return -ENODEV;
> @@ -1012,7 +1012,7 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
>  	owner = fcoe_netdev_to_module_owner(netdev);
>  	if (owner) {
>  		printk(KERN_DEBUG "foce:release driver module %s for %s\n",
> -		       owner->name, netdev->name);
> +		       module_name(owner), netdev->name);
>  		module_put(owner);
>  		return 0;
>  	}
> 
> 


-- 
~Randy
