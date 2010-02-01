Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0BAIvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:51:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51256 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab0BAIvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SuPLU8+eUqfQZCSz/wDdkh16r1MHIrBslUoI4a56t9h2bqgPL6flL17SEo2wtCj4EZ
         scQSb3zGxzGK6UqTtg/8NTgx6fiBiDgdjfJDU3jFqOLaj6ykLYi7YAuYutkb20wG0JT1
         QxjueOX/iZxz3c+Rf/uDNCjT2SXtLQBG5mWnA=
Subject: Re: [Patch] net: export TCP send buffer size via netlink
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
In-Reply-To: <20100201080256.4084.30962.sendpatchset@localhost.localdomain>
References: <20100201080256.4084.30962.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:51:49 +0100
Message-ID: <1265014309.2848.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 février 2010 à 02:59 -0500, Amerigo Wang a écrit :
> Currently, we can only get TCP send buffer size by
> getsockopt (SO_SNDBUF or TCP_INFO), this is not enough
> for the tools like netstat or ss to read.
> 
> Show TCP send buffer size via netlink NETLINK_INET_DIAG.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David Miller <davem@davemloft.net>
> 
> ---
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 7fee8a4..46768de 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -136,6 +136,7 @@ struct tcp_info {
>  	__u32	tcpi_ato;
>  	__u32	tcpi_snd_mss;
>  	__u32	tcpi_rcv_mss;
> +	__u32	tcpi_sndbuf;
>  
>  	__u32	tcpi_unacked;
>  	__u32	tcpi_sacked;

You cannot change tcp_info like this, this structure is used by some
programs, and they are going to break badly.



