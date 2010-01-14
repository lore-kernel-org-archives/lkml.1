Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269Ab0ANVAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0ANVAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018Ab0ANVAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:00:19 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39997 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0ANVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=AhdnIVvh6yapAUryn4lJFhsujLUt8A+2i70ynyNkUKexZAPSVy8KsB7VD7qRdcp+gq
         AfI0pG7kSbHgsjeUnSGKA2bFyz2/uRpdRYIaUFVNgyy4fsBa7K5dGLePXAq8t+xC3g9S
         rCpiRTw6dBb9JymGIiijov4kNCusQ5Mo7eGrE=
Date: Thu, 14 Jan 2010 19:00:01 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Networking Development Mailing List 
	<netdev@vger.kernel.org>
Subject: Re: [PATCH] [NET]: da.s_net not copied but assigned to itself in
 aarp_rcv()
Message-ID: <20100114210001.GE20221@ghostprotocols.net>
References: <4B4F7F4B.8000302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4F7F4B.8000302@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 14, 2010 at 09:32:11PM +0100, Roel Kluin escreveu:
> da.s_net was not copied but assigned to itself.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Looks right, must be there for ages...

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

> ---
> diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
> index 9d4adfd..f2b3b56 100644
> --- a/net/appletalk/aarp.c
> +++ b/net/appletalk/aarp.c
> @@ -819,7 +819,7 @@ static int aarp_rcv(struct sk_buff *skb, struct net_device *dev,
>  				ma = &ifa->address;
>  			else { /* We need to make a copy of the entry. */
>  				da.s_node = sa.s_node;
> -				da.s_net = da.s_net;
> +				da.s_net = sa.s_net;
>  				ma = &da;
>  			}
>  
