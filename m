Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbYKGHgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbYKGHgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYKGHf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:35:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48203
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbYKGHf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:35:58 -0500
Date: Thu, 06 Nov 2008 23:35:57 -0800 (PST)
Message-Id: <20081106.233557.193705310.davem@davemloft.net>
To: kay.sievers@vrfy.org
Cc: wli@holomorphy.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: sparc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1226018639.3189.15.camel@nga>
References: <1226018639.3189.15.camel@nga>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 07 Nov 2008 01:43:59 +0100

> --- a/arch/sparc/kernel/of_device.c
> +++ b/arch/sparc/kernel/of_device.c
> @@ -563,9 +563,9 @@ build_resources:
>  	op->dev.parent = parent;
>  	op->dev.bus = &of_platform_bus_type;
>  	if (!parent)
> -		strcpy(op->dev.bus_id, "root");
> +		dev_set_name(&op->dev, "root");
>  	else
> -		sprintf(op->dev.bus_id, "%08x", dp->node);
> +		dev_set_name(&op->dev, "%08x", dp->node);
>  
>  	if (of_device_register(op)) {
>  		printk("%s: Could not register of device.\n",

This part is OK.

> --- a/arch/sparc64/kernel/vio.c
> +++ b/arch/sparc64/kernel/vio.c
> @@ -224,7 +224,7 @@ static struct vio_dev *vio_create_one(st
>  	if (!strcmp(type, "domain-services-port"))
>  		bus_id_name = "ds";
>  
> -	if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
> +	if (strlen(bus_id_name) >= 20 - 4) {
>  		printk(KERN_ERR "VIO: bus_id_name [%s] is too long.\n",
>  		       bus_id_name);
>  		return NULL;
> 
> 

But I don't like this.

Could you please keep the macro around until everything is converted?
Then you can remove the test entirely.

Leaving it with just constants there is inviting confusion, no matter
how short amount of time it will be there.
