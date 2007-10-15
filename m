Return-Path: <linux-kernel-owner+w=401wt.eu-S1764840AbXJONBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764840AbXJONBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbXJONBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:01:05 -0400
Received: from userg502.nifty.com ([202.248.238.82]:57270 "EHLO
	userg502.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760115AbXJONBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:01:03 -0400
DomainKey-Signature: a=rsa-sha1; s=userg502; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=SADOlF5w+LDfFV1v5LQkPTPdU27h827hWtfwisSQy12kJpTv30RPZ8RxilNlvH4ln
	QSZX+BIzqYXgrl53oCL+Q==
X-Nifty-SrcIP: [220.145.30.228]
Date: Mon, 15 Oct 2007 21:59:49 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: shemminger@linux.foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [NOT VERY SAFE]     [TCP]: Set initial_ssthresh default to zero
 in Cubic and BIC.
Message-Id: <20071015215949.50399c00.komurojun-mbn@nifty.com>
In-Reply-To: <20071014135356.19754635.komurojun-mbn@nifty.com>
References: <20071006132601.f944f461.komurojun@nifty.com>
	<20071014073658.d4352b8c.komurojun@nifty.com>
	<20071014100245.914b784a.komurojun@nifty.com>
	<20071014132851.8d6a9de3.komurojun@nifty.com>
	<20071014135356.19754635.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear shemminger

>In which case it is zero because that is the default value.

The default value of snd_ssthresh is 0x7fffffff, isn't it?

[linux/net/ipv4/tcp_ipv4.c]
static int tcp_v4_init_sock(struct sock *sk)
...
        tp->snd_ssthresh = 0x7fffffff;  /* Infinity */
...

Best Regards
Komuro


> 
> Actually, tcp_sk(sk)->snd_ssthresh is not initialized,
> if initial_ssthresh is 0.
> 
> The patch should be
> 
>  static void bictcp_init(struct sock *sk)
>  {
>  	bictcp_reset(inet_csk_ca(sk));
> -	if (initial_ssthresh)
> -		tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
> +
> +	tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
>  }
>
