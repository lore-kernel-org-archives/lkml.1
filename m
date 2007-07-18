Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbXGRKAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbXGRKAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXGRJ74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:59:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:61926 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXGRJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iI+nlKHccR/xYuwOtoT4vXk+z7aNoZpSZVWQYze6TFjN8etv9KLRsJUyrR3TNIfkWo2vkNjqx+gzoQmDZp0GcR2iIBV6Ke2VSJXHOkNOhpk6RPe005n/7iGm1GGjJnUSBAE2udExb06u8PVR/bQAaQaYYqiEWjXOlmSO+jKYquY=
Message-ID: <91b13c310707180259v547ba2b3wc901102d35760a50@mail.gmail.com>
Date: Wed, 18 Jul 2007 17:59:52 +0800
From: "rae l" <crquan@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] [net/core] move dev_mc_discard from dev_mcast.c to dev.c
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, kaber@coreworks.de, linux-kernel@vger.kernel.org
In-Reply-To: <20070718.021107.40833440.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11846606051099-git-send-email-crquan@gmail.com>
	 <11847264651509-git-send-email-crquan@gmail.com>
	 <20070718.021107.40833440.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, David Miller <davem@davemloft.net> wrote:
> From: Denis Cheng <crquan@gmail.com>
> Date: Wed, 18 Jul 2007 10:41:03 +0800
>
> > Because this function is only called by unregister_netdevice,
> > this moving could make this non-global function static,
> > and also remove its declaration in netdevice.h;
> >
> > Any further, function __dev_addr_discard is also just called by
> > dev_mc_discard and dev_unicast_discard, keeping this two functions
> > both in one c file could make __dev_addr_discard also static
> > and remove its declaration in netdevice.h;
> >
> > Futhermore, the sequential call to dev_unicast_discard and then
> > dev_mc_discard in unregister_netdevice have a similar mechanism that:
> > (netif_tx_lock_bh / __dev_addr_discard / netif_tx_unlock_bh),
> > they should merged into one to eliminate duplicates in acquiring and
> > releasing the dev->_xmit_lock, this would be done in my following patch.
> >
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
>
> Patch applied, thanks.
Thanks for applying, too.

And then the dev_mcast.c is now only 256 lines long(versus dev.c 4052 lines),
just left a few multicast related functions definition and "dev_mcast"
procfs code,
I have an idea to merge all code dev_mcast.c into dev.c, that would:

- remove two functions (__dev_addr_delete, __dev_set_rx_mode) from netdevice.h,
  and then tag them static,
  those two are also defined in dev.c and only called from dev_mcast.c,

- reducing one file would benefit the compilation process.

All in one word, I don't think the single file dev_mcast.c is needed anymore.

>


-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
