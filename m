Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYIZQGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYIZQGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 12:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYIZQG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 12:06:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:1865 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYIZQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 12:06:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hTP4nVrGdaPB0SpKuxBIcQye1Pw3jNa/GVHsLWxbqc2tixMNNaNdWBSLT0/6tJyXOu
         eBIN6YUasga7zWoAYVeDlUjPQyixxzmu58L7KswP1ZbdCQQyYn9juTWp/kYH1llL9FM8
         SHFTFaqtJlbhM2njsRbzsM5qjIEKb2VSAtfEs=
Message-ID: <7fcc02550809260906o35861a95se54aa76261923300@mail.gmail.com>
Date: Fri, 26 Sep 2008 11:06:24 -0500
From: Tammy <tammy000@gmail.com>
To: Komuro <komurojun-mbn@nifty.com>
Subject: Re: [PATCH git latest] drivers/net: fixing a datarace related to update_stats()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080926222920.f251696e.komurojun-mbn@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	 <20080922215617.GA13057@comet.dominikbrodowski.net>
	 <20080922231227.2625dd09@lxorguk.ukuu.org.uk>
	 <20080922222655.GA3792@isilmar.linta.de>
	 <20080923001534.13031535@lxorguk.ukuu.org.uk>
	 <20080926222920.f251696e.komurojun-mbn@nifty.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You need two braces...
>
> -       if ((inw(ioaddr+EL3_STATUS) & 0xe000) == 0x2000)
> +       if ((inw(ioaddr+EL3_STATUS) & 0xe000) == 0x2000) {
> +           spin_lock_irqsave(&lp->lock, flags);
>            update_stats(dev);
> +           spin_unlock_irqrestore(&lp->lock, flags);
> +       }
>     }
>


Thanks a lot. I will resubmit the patch then.

Lin
