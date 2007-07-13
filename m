Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbXGMW3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbXGMW3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXGMW30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:29:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbXGMW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:29:25 -0400
Message-ID: <4697FCBD.7050003@zytor.com>
Date: Fri, 13 Jul 2007 15:29:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] broken lilo check on make install
References: <46969586.5050507@googlemail.com>
In-Reply-To: <46969586.5050507@googlemail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> 
> I don't use and don't have lilo installed on this system. The attached
> patch fixes the problem for me.
> 

You also don't have a /sbin/installkernel, which is arguably a bug too.
 However, the patch mostly makes sense, although I would suggest putting
a "sync" in the else clause.

With that caveat, Acked-by: H. Peter Anvin <hpa@zytor.com>

> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> 
> 
> diff --git a/arch/i386/boot/install.sh b/arch/i386/boot/install.sh
> index 5e44c73..7099fd6 100644
> --- a/arch/i386/boot/install.sh
> +++ b/arch/i386/boot/install.sh
> @@ -51,4 +51,10 @@ fi
>  cat $2 > $4/vmlinuz
>  cp $3 $4/System.map
>  
> -if [ -x /sbin/lilo ]; then /sbin/lilo; else /etc/lilo/install; fi
> +if [ -x /sbin/lilo ]; then
> +       /sbin/lilo
> +elif [ -x /etc/lilo/install ]; then
> +       /etc/lilo/install
> +else
> +       echo "Cannot find LILO."
> +fi
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
