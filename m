Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXBQWBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXBQWBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 17:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXBQWBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 17:01:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:55178 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbXBQWBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 17:01:01 -0500
Subject: Re: [PATCH 2.6.21-rc1] powerpc: Make of_device_uevent() compatible
	with ibmebus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com, Sylvain Munaut <tnt@246tnt.com>, fenkes@de.ibm.com,
       pmac@au1.ibm.com
In-Reply-To: <200702171728.15597.hnguyen@linux.vnet.ibm.com>
References: <200702171728.15597.hnguyen@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 08:56:39 +1100
Message-Id: <1171749399.5644.145.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 17:28 +0100, Hoang-Nam Nguyen wrote:
> ibmebus has a fake root device that's not associated with an ofdt node.
> Filter out any such devices in of_device_uevent().

Doh ! You are creating an of_device with no attached device-node ? That
is totally evil ! Why do you need that ?

Ben.

> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
> ---
> 
> 
>  of_device.c |    4 ++++
>  1 files changed, 4 insertions(+)
> 
> 
> diff -urp a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
> --- a/arch/powerpc/kernel/of_device.c	2007-02-17 16:36:32.116368480 +0100
> +++ b/arch/powerpc/kernel/of_device.c	2007-02-17 16:44:01.319366352 +0100
> @@ -180,6 +180,10 @@ int of_device_uevent(struct device *dev,
>  
>  	ofdev = to_of_device(dev);
>  
> +	/* e.g. ibmebus has a fake root device w/o ofdt node -- filter that */
> +	if (!ofdev->node)
> +		return -ENODEV;
> +
>  	if (add_uevent_var(envp, num_envp, &i,
>  			   buffer, buffer_size, &length,
>  			   "OF_NAME=%s", ofdev->node->name))
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

