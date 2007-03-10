Return-Path: <linux-kernel-owner+w=401wt.eu-S1161022AbXCJJPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022AbXCJJPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160995AbXCJJPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:15:31 -0500
Received: from mail.kroah.org ([69.55.234.183]:54790 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426AbXCJJPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:15:20 -0500
Date: Sat, 10 Mar 2007 01:14:45 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       netfilter-devel@lists.netfilter.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
       torvalds@linux-foundation.org, Patrick McHardy <kaber@trash.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 12/20] nfnetlink_log: fix reference counting
Message-ID: <20070310091445.GA26611@kroah.com>
References: <20070310061234.465093436@mini.kroah.org> <20070310061803.GM31412@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310061803.GM31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 10:18:03PM -0800, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> 
> [NETFILTER]: nfnetlink_log: fix reference counting
> 
> Fix reference counting (memory leak) problem in __nfulnl_send() and callers
> related to packet queueing.
> 
> Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  net/netfilter/nfnetlink_log.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -220,7 +220,8 @@ _instance_destroy2(struct nfulnl_instanc
>  		/* timer "holds" one reference (we have one more) */
>  		if (timer_pending(&inst->timer)) {
>  			del_timer(&inst->timer);
> -			instance_put(inst);
> +
> +instance_put(inst);
>  		}
>  		if (inst->qlen)
>  			__nfulnl_send(inst);
> 

As this patch does nothing, it's now dropped.  It was my fault as the
original patch didn't apply and I messed up using quilt here.

thanks,

greg k-h
