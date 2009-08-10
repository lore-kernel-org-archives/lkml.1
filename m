Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZHJGgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZHJGgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZHJGgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:36:12 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60319 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZHJGgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:36:11 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH 10/14] infiniband: use printk_once
Date: Mon, 10 Aug 2009 09:36:26 +0300
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com> <1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com> <adaocqo9sb4.fsf@cisco.com>
In-Reply-To: <adaocqo9sb4.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908100936.26963.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a bit nervous about this one.  
printk_once will print once ONLY if CONFIG_PRINTK is set in include/linux/autoconf.h
(i.e., when the kernel is configured).  Otherwise, it gets defined to printk --
and it will always print in this case.
(see 2.6.30.xx kernel include file "include/linux/kernel.h", lines 235, 249, and 272).

Do you think that distributions will ALWAYS have CONFIG_PRINTK defined?

I would prefer to wait until printk_once printing only once is not config-dependent.

-Jack

On Monday 10 August 2009 08:00, Roland Dreier wrote:
> 
>  >  drivers/infiniband/hw/cxgb3/iwch.c |    4 +---
>  >  drivers/infiniband/hw/mlx4/main.c  |    6 +-----
> 
>  > --- a/drivers/infiniband/hw/mlx4/main.c
>  > +++ b/drivers/infiniband/hw/mlx4/main.c
>  > @@ -540,15 +540,11 @@ static struct device_attribute *mlx4_class_attributes[] = {
>  >  
>  >  static void *mlx4_ib_add(struct mlx4_dev *dev)
>  >  {
>  > -	static int mlx4_ib_version_printed;
>  >  	struct mlx4_ib_dev *ibdev;
>  >  	int num_ports = 0;
>  >  	int i;
>  >  
>  > -	if (!mlx4_ib_version_printed) {
>  > -		printk(KERN_INFO "%s", mlx4_ib_version);
>  > -		++mlx4_ib_version_printed;
>  > -	}
>  > +	printk_once(KERN_INFO "%s", mlx4_ib_version);
>  >  
>  >  	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
>  >  		num_ports++;
> 
> Looks fine but there is near-identical code in
> drivers/infiniband/hw/mthca/mthca_main.c that you might as well convert
> too.
> 
> Thanks,
>   Roland
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general
> 
