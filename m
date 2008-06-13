Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYFMQBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYFMQBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbYFMQAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:00:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:52139 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbYFMQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gy1NF3wUSMXaKuCa2slXNjm5ZwTz1UHRinJS61at6oS5oqB07M7fchr7yXZGWYpK0j
         SjNkeXZDiRq0Q6y3U4vLeQriOHkiR1IhEdOa0cxGP5OAs6z5jOW7GGWhTsq1Exn9v84S
         i9V+ZzZy4zRpXTJU+3hz+kCn3X+lw/sI+fDHs=
Message-ID: <c49e66200806130900i26b3c284q262aef2d85d61f61@mail.gmail.com>
Date: Fri, 13 Jun 2008 18:00:53 +0200
From: "Pieter Steyn" <pieterste@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eth_v10.c phy fix
Cc: jesper.nilsson@axis.com
In-Reply-To: <c49e66200806130804u280fdfa1gd1027f3401ae7f4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c49e66200806130804u280fdfa1gd1027f3401ae7f4f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I did not consider case when searching...DOH! :]

I've now cc'ed in Jesper who seems to be the maintainer.

Cheers,
Pieter Steyn

> On 6/13/08, Pieter Steyn <pieterste@gmail.com> wrote:
> Hi guys,
>
>  This patch allows you to set phy address parameters through ethtool, like:
>
>  /bin/ethtool -s eth0 phyad 8
>
>  --- drivers/net/cris/eth_v10.c  2008-06-12 14:12:33.000000000 +0200
>  +++ drivers/net/cris/eth_v10.c  2008-06-12 14:19:35.000000000 +0200
>  @@ -1430,7 +1430,11 @@
>                 e100_set_duplex(dev, ecmd->duplex == DUPLEX_HALF ? half : full);
>                 e100_set_speed(dev, ecmd->speed == SPEED_10 ? 10: 100);
>         }
>  -
>  +        //Honor ethtool phy address parameter, which was simply
>  discarded before this.
>  +        if (ecmd->phy_address <= 31)
>  +                mdio_phy_addr = ecmd->phy_address;
>  +        else if (ecmd->phy_address == 32)
>  +                return -ENODEV;
>         return 0;
>   }
>
>  I've searched the MAINTAINERS file and haven't seen anything regarding
>  either the source file name or cris.  Please consider applying my
>  patch to main kernel...
>
>  Thanks,
>
> Pieter Steyn
>
>
