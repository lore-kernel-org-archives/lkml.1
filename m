Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZGAK2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZGAK2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGAK2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:28:35 -0400
Received: from stinky.trash.net ([213.144.137.162]:54592 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZGAK2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:28:34 -0400
Message-ID: <4A4B3A4B.9000502@trash.net>
Date: Wed, 01 Jul 2009 12:28:27 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andreas Jaggi <aj@open.ch>
CC: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, davem@davemloft.net,
       linux-kernel@vger.kernel.org, shemminger@osdl.org
Subject: Re: [PATCH] gre: copy ToS/DiffServ bits to outer IP header
References: <4A48BC82.6040801@open.ch> <4A48C643.5030709@trash.net> <4A49D55A.4050600@open.ch>
In-Reply-To: <4A49D55A.4050600@open.ch>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Jaggi wrote:
> Now using the rtnl_link interface.

Your patches are seriously whitespace-damaged. Please make sure
to send them properly (test by sending to yourself first).

> diff -urN vanilla-linux-2.6.29.4/include/linux/if_tunnel.h 
> dev-gre/include/linux/if_tunnel.h
> --- vanilla-linux-2.6.29.4/include/linux/if_tunnel.h    2009-05-19 
> 01:52:34.000000000 +0200
> +++ dev-gre/include/linux/if_tunnel.h    2009-06-30 08:22:52.000000000 
> +0200
> @@ -34,6 +34,7 @@
>     __be32            i_key;
>     __be32            o_key;
>     struct iphdr        iph;
> +    __u8            copy_tos;

You can't change this structure, this will break compatibility.

> };
> 
> /* SIT-mode i_flags */
> @@ -63,6 +64,7 @@
>     IFLA_GRE_REMOTE,
>     IFLA_GRE_TTL,
>     IFLA_GRE_TOS,
> +    IFLA_GRE_COPY_TOS,
>     IFLA_GRE_PMTUDISC,
>     __IFLA_GRE_MAX,

You can't add new attributes in the middle, they need to be added at
the end.
