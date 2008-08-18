Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYHRX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYHRX2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 19:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYHRX2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 19:28:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34522 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYHRX2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 19:28:34 -0400
Date: Mon, 18 Aug 2008 16:28:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] rcuclassic: fix compiler warning
Message-ID: <20080818232830.GG6732@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48A9EC09.4060701@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9EC09.4060701@ct.jp.nec.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 02:39:21PM -0700, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
>   CC      kernel/rcuclassic.o
> kernel/rcuclassic.c: In function 'rcu_init_percpu_data':
> kernel/rcuclassic.c:705: warning: comparison of distinct pointer types lacks a cast
> kernel/rcuclassic.c:713: warning: comparison of distinct pointer types lacks a cast
> 
> flags should be unsigned long.

You beat me to it!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  kernel/rcuclassic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index fb1f1cc..86ff6d6 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -700,7 +700,7 @@ void rcu_check_callbacks(int cpu, int user)
>  static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
>  						struct rcu_data *rdp)
>  {
> -	long flags;
> +	unsigned long flags;
> 
>  	spin_lock_irqsave(&rcp->lock, flags);
>  	memset(rdp, 0, sizeof(*rdp));
> -- 
> 1.5.6
> 
