Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZLATC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZLATC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 14:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZLATCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 14:02:55 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:36281 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZLATCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 14:02:54 -0500
Message-ID: <4B156862.5020903@hp.com>
Date: Tue, 01 Dec 2009 14:02:58 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrei Pelinescu-Onciul <andrei@iptel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH] sctp: fix sctp_setsockopt_autoclose compile warning
References: <20091130164015.9bb8f6a3.sfr@canb.auug.org.au> <20091130094929.GY10897@shell.iptel.org> <20091130095250.GZ10897@shell.iptel.org>
In-Reply-To: <20091130095250.GZ10897@shell.iptel.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrei Pelinescu-Onciul wrote:
> Fix the following warning, when building on 64 bits:
> 
> net/sctp/socket.c:2091: warning: large integer implicitly
>                         truncated to unsigned type
> 
> Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>

Ack.

-vlad

> ---
>  net/sctp/socket.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 71513b3..8961863 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2088,7 +2088,7 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
>  		return -EFAULT;
>  	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
>  	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
> -		sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ ;
> +		sp->autoclose = (__u32)(MAX_SCHEDULE_TIMEOUT / HZ) ;
>  
>  	return 0;
>  }
