Return-Path: <linux-kernel-owner+w=401wt.eu-S1761163AbXH1VZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163AbXH1VZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXH1VZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:25:05 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:6454 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbXH1VZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:25:04 -0400
Message-ID: <46D492A7.8040301@chelsio.com>
Date: Tue, 28 Aug 2007 14:24:55 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.23 RESEND] cxgb3 - Fix dev->priv usage
References: <20070823220628.9835.73819.stgit@speedy5>	<46CFA8E8.90101@garzik.org> <46CFCCDF.9060101@garzik.org> <adahcmjcqca.fsf@cisco.com>
In-Reply-To: <adahcmjcqca.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Aug 2007 21:23:33.0493 (UTC) FILETIME=[B008B250:01C7E9B9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > I take that back.  Rejected -- it breaks infiniband build.
>
> To be more precise:
>
>     drivers/infiniband/hw/cxgb3/cxio_hal.c: In function 'cxio_rdev_open':
>     drivers/infiniband/hw/cxgb3/cxio_hal.c:919: error: implicit declaration of function 'T3CDEV'
>
> it seems the problem is that T3CDEV() has been deleted and been
> replaced with the dev2t3cdev() inline function.  However a simple
> replacement s/T3CDEV/dev2t3cdev/ in drivers/infiniband/hw/cxgb3
> doesn't work because the function has moved from t3cdev.h to
> adapter.h; and moving the function back to t3cdev.h doesn't work
> because it depends on more structure definitions now.
>
> And at that point I gave up...
>   

Sorry about the compilation issue and the delay to reply.
I'll post a follow up for the iw_cxgb3 driver later this evening.
I plan to move the inlined dev2t3cdev() from adapter.h to an exported 
dev2t3cdev()
in cxgb3_offload.c.

Divy
