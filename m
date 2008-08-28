Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYH1Si7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYH1Si7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYH1Siv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:38:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:16346 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYH1Siu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e9ft8OlkbMF2XhBSjEjYlbIHvg9spWF7ieGjeMJsBk/Z9+b75iv+jn+/ONWvwUJ9Qt
         OIsyojuErHfZt4GfAzA7MC+1x9KrzwRYvkLyiw/yVECVM6xdEgQQNS5b4dqMhjG0aTT5
         MbQof0x5y+eX0HrnLaCF8nSKGh6XeQcJMff7M=
Date: Thu, 28 Aug 2008 22:40:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
Message-ID: <20080828184025.GA22165@x200.localdomain>
References: <20080828183223.GA30781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828183223.GA30781@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
> How do you feel about this patch? It's all about making kmemcheck more
> useful... and not much else. Does it have any chance of entering the
> kernel along with kmemcheck (when/if that happens)?

DEFINE_BITFIELD is horrible.

> @@ -285,11 +286,12 @@ struct sk_buff {
>  		};
>  	};
>  	__u32			priority;
> -	__u8			local_df:1,
> +	DEFINE_BITFIELD(__u8,	flags1,
> +				local_df:1,
>  				cloned:1,
>  				ip_summed:2,
>  				nohdr:1,
> -				nfctinfo:3;
> +				nfctinfo:3);
>  	__u8			pkt_type:3,
>  				fclone:2,
>  				ipvs_property:1,

