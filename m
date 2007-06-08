Return-Path: <linux-kernel-owner+w=401wt.eu-S964905AbXFHGfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbXFHGfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbXFHGfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:35:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:58426 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbXFHGfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i6GcMvk6uGW79cDlpa6Rx7M0oxkl/kzrFanrNggRqgAKxaIwZw4JLNcyFXrcK5wUdfdSSwPMlyOaxZlDon0L+ZDV6XZ1pdQs+XQuw3fdMiQfnVDsqNXQil/wz9QybK5iU6/MAN1cNKBR3Qxk/pEQiqGCPTExVTNNlxTjSPOhngM=
Message-ID: <a44ae5cd0706072335w6244f267x1fb0158dd536085c@mail.gmail.com>
Date: Thu, 7 Jun 2007 23:35:17 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Miles Lane" <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.22-rc4-mm2 -- ipw2200 -- SIOCSIFADDR: No buffer space available
In-Reply-To: <20070607222015.GA14966@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <a44ae5cd0706071125p2079472eme52821bd134d26b0@mail.gmail.com>
	 <20070607131559.cd95a181.akpm@linux-foundation.org>
	 <20070607222015.GA14966@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
[...]
> Miles, could you try if this patch helps?
>
> Björn
>
>
> Stop destroying devices when all of their ifas are gone, as we no longer
> recreate them when ifas are added.
>
> Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> --
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index fa97b96..abf6352 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -327,12 +327,8 @@ static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
>                 }
>
>         }
> -       if (destroy) {
> +       if (destroy)
>                 inet_free_ifa(ifa1);
> -
> -               if (!in_dev->ifa_list)
> -                       inetdev_destroy(in_dev);
> -       }
>  }
>
>  static void inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
>

Björn,

Thanks.  You patch worked for me.

             Miles
