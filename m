Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYEMWWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYEMWWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYEMWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:22:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55357
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbYEMWWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:22:36 -0400
Date: Tue, 13 May 2008 15:22:31 -0700 (PDT)
Message-Id: <20080513.152231.109481008.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18473.60551.911448.98269@alkaid.it.uu.se>
References: <20080512.153628.193699676.davem@davemloft.net>
	<20080512.153948.193688062.davem@davemloft.net>
	<18473.60551.911448.98269@alkaid.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Tue, 13 May 2008 21:31:19 +0200

> David Miller writes:
>  > Try this patch instead, thanks!
> 
> Ok, reverting previous patch and applying this done results in:
 ...
> lmb_dump_all:
>     memory.cnt		  = 0x4
>     memory.size		  = 0xff40000
>     memory.region[0x0].base       = 0x0
> 		      .size     = 0x8000000
>     memory.region[0x1].base       = 0x10000000
> 		      .size     = 0x7efe000
>     memory.region[0x2].base       = 0x17f00000
> 		      .size     = 0x3a000
>     memory.region[0x3].base       = 0x17f3e000
> 		      .size     = 0x8000
>     reserved.cnt	  = 0x4
>     reserved.size	  = 0x0
>     reserved.region[0x0].base       = 0x7ffc000
> 		      .size     = 0x2000
>     reserved.region[0x1].base       = 0x7fff040
> 		      .size     = 0xfc0
>     reserved.region[0x2].base       = 0x10000000
> 		      .size     = 0x35bf60
>     reserved.region[0x3].base       = 0x107e8e00
> 		      .size     = 0x10b9a751

Yeah, those last two reserved regions are where your 128MB went to,
as I suspected.

Thanks I'll try to figure out where to go from here.
