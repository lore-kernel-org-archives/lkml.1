Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYFRMJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYFRMJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYFRMJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:09:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:2814 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYFRMJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f6mwAcVYfdhGpQ+h8RnS6wCCLNRvdxgu38qvJfrBIjLzmUfwXHfWELmicsFCfG8UW8
         nOnX7lHzYb29XtuRR9kLJ6S4WjsX7SQzlUFJxk5MuJPnaWku44qoXxbZZ1FGLBlN392G
         dK6L8n1cdWMMYdN/dEzEHxJmDFLUHAVORSHo4=
Message-ID: <c49e66200806180509g6a391f8fi1567f21cd353c71c@mail.gmail.com>
Date: Wed, 18 Jun 2008 14:09:23 +0200
From: "Pieter Steyn" <pieterste@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eth_v10.c phy fix
Cc: jesper.nilsson@axis.com
In-Reply-To: <c49e66200806130900i26b3c284q262aef2d85d61f61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c49e66200806130804u280fdfa1gd1027f3401ae7f4f@mail.gmail.com>
	 <c49e66200806130900i26b3c284q262aef2d85d61f61@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Any word on this?

Thanks,
Pieter

> On 6/13/08, Pieter Steyn <pieterste@gmail.com> wrote:
> Ah, I did not consider case when searching...DOH! :]
>
>  I've now cc'ed in Jesper who seems to be the maintainer.
>
>  Cheers,
>
> Pieter Steyn
>
>
>  > On 6/13/08, Pieter Steyn <pieterste@gmail.com> wrote:
>  > Hi guys,
>  >
>  >  This patch allows you to set phy address parameters through ethtool, like:
>  >
>  >  /bin/ethtool -s eth0 phyad 8
>  >
>  >  --- drivers/net/cris/eth_v10.c  2008-06-12 14:12:33.000000000 +0200
>  >  +++ drivers/net/cris/eth_v10.c  2008-06-12 14:19:35.000000000 +0200
>  >  @@ -1430,7 +1430,11 @@
>  >                 e100_set_duplex(dev, ecmd->duplex == DUPLEX_HALF ? half : full);
>  >                 e100_set_speed(dev, ecmd->speed == SPEED_10 ? 10: 100);
>  >         }
>  >  -
>  >  +        //Honor ethtool phy address parameter, which was simply
>  >  discarded before this.
>  >  +        if (ecmd->phy_address <= 31)
>  >  +                mdio_phy_addr = ecmd->phy_address;
>  >  +        else if (ecmd->phy_address == 32)
>  >  +                return -ENODEV;
>  >         return 0;
>  >   }
>  >
>  >  I've searched the MAINTAINERS file and haven't seen anything regarding
>  >  either the source file name or cris.  Please consider applying my
>  >  patch to main kernel...
>  >
>  >  Thanks,
>  >
>  > Pieter Steyn
>  >
>  >
>
