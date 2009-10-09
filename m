Return-Path: <linux-kernel-owner+w=401wt.eu-S934720AbZJIWIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbZJIWIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZJIWIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:08:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35153
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870AbZJIWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:08:34 -0400
Date: Fri, 09 Oct 2009 15:08:29 -0700 (PDT)
Message-Id: <20091009.150829.218507309.davem@davemloft.net>
To: heyongli@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux guest domain with two vnets bound to the same vswitch
 experiences hung in bootup (sun_netraT5220)
From: David Miller <davem@davemloft.net>
In-Reply-To: <505766fa0909231903t2fe2f7b6y26d2681d6d38ef0e@mail.gmail.com>
References: <505766fa0909222137q217be3d0x8fc12ab467833666@mail.gmail.com>
	<505766fa0909230040m13e3dc34x2ceb83848767d825@mail.gmail.com>
	<505766fa0909231903t2fe2f7b6y26d2681d6d38ef0e@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hyl <heyongli@gmail.com>
Date: Thu, 24 Sep 2009 10:03:25 +0800

> Subject: [PATCH] Sun ldom vnet driver dead lock
> 
> if 2 vnet attach to same vswitch, ldom will report
> 2 same irq then lead to dead lock on the lp->lock
> or the vio->lock
> 
> static irqreturn_t ldc_rx(int irq, void *dev_id){
> ...
> out:
> 	spin_unlock_irqrestore(&lp->lock, flags);
>            << here run with out any lock
> 	send_events(lp, event_mask);
>            >> vnet evetn process will dead lock on
>            >> lp->lock or the vio->lock
> 
> Signed-off-by: Yongli He <heyongli@gmail.com>

Thank you for this bug report and patch, I am looking at
it now.
