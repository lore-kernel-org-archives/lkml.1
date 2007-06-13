Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbXFMREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbXFMREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbXFMREK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:04:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:30027 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbXFMREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B3RXkNVikAsvz31wiGfIbuoe/EyaumOCUQ78Gs4d3G4jI0lgY9S5tsUqnTPNGW4PWnbmhiBOLVOMHJWs4Cd9vLqB6Lybgli6jEq7HlNjUZ/h4+FAE+oO486vhrkEo3jOFjgeLZhP5AAQ+HXZDPholuCOsA/lG0ZZDuoLZioF2J8=
Message-ID: <a781481a0706131004q722bb409tcd4e1d13102bfb8c@mail.gmail.com>
Date: Wed, 13 Jun 2007 22:34:07 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take5 5/7] switch function of netpoll
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <466FC72A.3090508@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FC455.5060001@bx.jp.nec.com> <466FC72A.3090508@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keiichi,

On 6/13/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> From: Keiichi KII <k-keiichi@bx.jp.nec.com>
>
> This patch contains switch function of netpoll.
>
> If "enabled" attribute of certain port is '1', this port is used
> and the configurations of this port are unable to change.
>
> If "enabled" attribute of certain port is '0', this port isn't used
> and the configurations of this port are able to change.
>
> -+- /sys/class/misc/
> |-+- netconsole/
>   |-+- port1/
>   | |--- id          [r--r--r--]  id
>   | |--- enabled     [rw-r--r--]  0: disable 1: enable, writable
>   | ...
>   |--- port2/
>   ...
>
> Signed-off-by: Keiichi KII <k-keiichi@bx.jp.nec.com>
> Signed-off-by: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
> ---
> Index: mm/drivers/net/netconsole.c
> ===================================================================
> --- mm.orig/drivers/net/netconsole.c
> +++ mm/drivers/net/netconsole.c
> @@ -71,6 +71,7 @@ struct netconsole_target {
>         struct list_head list;
>         struct kobject obj;
>         int id;
> +       int enabled;
>         struct netpoll np;
>  };

I really think you need to document/comment the struct members.
The newly introduced "enabled" for example, is serving a dual-purpose
in your code here (like you mention in the Changelog). It's used not
only to enable/disable a target, but also to ensure atomicity when
changing the (multiple) configurable parameters of a given target ...
the first purpose is self-evident from the name, but the second is
non-obvious. A sysfs node is also a userspace interface, so some
explicit mention of this is required.

Satyam
