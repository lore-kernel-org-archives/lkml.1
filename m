Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZKSVTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZKSVTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZKSVTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:19:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58197
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965AbZKSVTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:19:34 -0500
Date: Thu, 19 Nov 2009 13:19:51 -0800 (PST)
Message-Id: <20091119.131951.26921972.davem@davemloft.net>
To: David.Choi@Micrel.Com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, greg@kroah.com
Subject: Re: [PATCH 2.6.32-rc6] drivers/net: ks8851_mll ethernet network
 driver 
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091119.122734.89781869.davem@davemloft.net>
References: <C43529A246480145B0A6D0234BDB0F0D021299@MELANITE.micrel.com>
	<20091119.122734.89781869.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 19 Nov 2009 12:27:34 -0800 (PST)

> From: "Choi, David" <David.Choi@Micrel.Com>
> Date: Tue, 17 Nov 2009 15:02:36 -0800
> 
>> This patch is for ks8851 16bit MLL Ethernet network device driver in order to fix bugs and to enhance functions.
>  ...
>> Signed-off-by: David J. Choi <david.choi@micrel.com>
> 
> Applied.

Sorry I had to revert this, it adds new warnings to the
build.

You can't cast pointers to 'int' in order to print them,
that emits a warning on 64-bit systems because you're
truncating the top bits.

There is really no point in printing __iomem pointers,
those are very architecture specific.  So is the IRQ
number.

I would just remove this part of your patch entirely
(don't forget to update the commit message to match).

Please fix this up and resubmit, thank you.
