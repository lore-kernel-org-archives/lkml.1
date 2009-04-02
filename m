Return-Path: <linux-kernel-owner+w=401wt.eu-S1764872AbZDBPHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764872AbZDBPHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763817AbZDBPDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:03:09 -0400
Received: from fmailhost03.isp.att.net ([207.115.11.53]:38117 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763918AbZDBPDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:03:08 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49D4D37A.50504@lwfinger.net>
Date: Thu, 02 Apr 2009 10:02:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       oliver@neukum.org
Subject: Re: [PATCH 1/2 V3] kaweth: Fix locking to be SMP-safe
References: <20090402100223.GA30905@gondor.apana.org.au>
In-Reply-To: <20090402100223.GA30905@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> @@ -796,7 +795,7 @@ static int kaweth_start_xmit(struct sk_b
>>
>>        int res;
>>
>> -       spin_lock(&kaweth->device_lock);
>> +       spin_lock_irq(&kaweth->device_lock);
> 
> Should be irqsave unless you don't expect to be called via netpoll.

The .ndo_poll_controller callback is left at NULL in this driver. I believe the
patch to be OK.

Larry
