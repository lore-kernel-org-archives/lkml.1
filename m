Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbZHJFAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbZHJFAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 01:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZHJFAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 01:00:32 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:22770 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZHJFAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 01:00:31 -0400
X-IronPort-AV: E=Sophos;i="4.43,351,1246838400"; 
   d="scan'208";a="193892169"
From: Roland Dreier <rdreier@cisco.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org
Subject: Re: [PATCH 10/14] infiniband: use printk_once
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	<1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 09 Aug 2009 22:00:31 -0700
In-Reply-To: <1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com>
	(Marcin Slusarz's message of "Sun, 9 Aug 2009 21:54:05 +0200")
Message-ID: <adaocqo9sb4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Aug 2009 05:00:32.0496 (UTC) FILETIME=[7D268700:01CA1977]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >  drivers/infiniband/hw/cxgb3/iwch.c |    4 +---
 >  drivers/infiniband/hw/mlx4/main.c  |    6 +-----

 > --- a/drivers/infiniband/hw/mlx4/main.c
 > +++ b/drivers/infiniband/hw/mlx4/main.c
 > @@ -540,15 +540,11 @@ static struct device_attribute *mlx4_class_attributes[] = {
 >  
 >  static void *mlx4_ib_add(struct mlx4_dev *dev)
 >  {
 > -	static int mlx4_ib_version_printed;
 >  	struct mlx4_ib_dev *ibdev;
 >  	int num_ports = 0;
 >  	int i;
 >  
 > -	if (!mlx4_ib_version_printed) {
 > -		printk(KERN_INFO "%s", mlx4_ib_version);
 > -		++mlx4_ib_version_printed;
 > -	}
 > +	printk_once(KERN_INFO "%s", mlx4_ib_version);
 >  
 >  	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
 >  		num_ports++;

Looks fine but there is near-identical code in
drivers/infiniband/hw/mthca/mthca_main.c that you might as well convert
too.

Thanks,
  Roland
