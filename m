Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0CHMw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 07:52:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0CHMww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 07:52:52 -0500
Date: Mon, 8 Mar 2010 13:51:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: inconsistent lock state
Message-ID: <20100308125122.GA11242@redhat.com>
References: <20100307192305.GA598@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100307192305.GA598@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky wrote:
>
> Hello,
>
> Hardly reproducible.
> /*
> * 2.6.33. x86. ASUS f3jc
> */
>
> [329645.010697] =================================
> [329645.010699] [ INFO: inconsistent lock state ]
> [329645.010703] 2.6.33-33-0-dbg #31
> [329645.010705] ---------------------------------
> [329645.010708] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
>
> ...
>
> [329645.011083]  [<c128858d>] netif_receive_skb+0x340/0x360
> [329645.011093]  [<fd1ab6f4>] rtl8169_rx_interrupt+0x2bf/0x37e [r8169]
> [329645.011100]  [<fd1aba02>] rtl8169_reset_task+0x38/0xcd [r8169]
> [329645.011105]  [<c1044f71>] worker_thread+0x1ac/0x27c

I don't understand this code, but at first glance drivers/net/r8169.c
is obviously buggy.

The work->func, rtl8169_reset_task(), calls rtl8169_rx_interrupt() ->
netif_receive_skb(), and the last one may only be called from softirq.

Oleg.


