Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbXC1UeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbXC1UeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXC1UeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:34:16 -0400
Received: from xdsler061.osnanet.de ([89.166.177.61]:1355 "EHLO
	Marvin.DL8BCU.ampr.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932881AbXC1UeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:34:14 -0400
Date: Wed, 28 Mar 2007 18:55:34 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Neil Brown <neilb@suse.de>
Cc: Phy Prabab <phyprabab@gmail.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Odd log message associated with NFS
Message-ID: <20070328185534.GA585@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>,
	Neil Brown <neilb@suse.de>, Phy Prabab <phyprabab@gmail.com>,
	nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <2fe399760703271140l703c2791oa84e9e1832487dcb@mail.gmail.com> <20070327193909.GA585@ds20.borg.net> <17929.53448.506302.615732@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17929.53448.506302.615732@notabene.brown>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 12:19:52PM +1000, Neil Brown wrote:
> On Tuesday March 27, dl8bcu@dl8bcu.de wrote:
> > On Tue, Mar 27, 2007 at 11:40:48AM -0700, Phy Prabab wrote:
> > > kernel: rpcsvc: received unknown control message:-2144992132/-1
> > 
> > Just a 'me, too':
> 
> For the 'unknown control message' messages,
> see:   "fix typo in svc_udp_recvfrom"  previously on
> nfs@lists.sourceforge.net.
> 
> Fix is in -mm and below.

will try, thanks.
 
> For "svc: bad direction" .... Don't know... garbage on the net maybe?
> Or maybe not.  I have seen something like that before, but haven't

I don't think so as it would mean corruption at other places, too. The
Network is quite uninteresting: single ethernet segment, 2 switches
involved, longest cable 8 meters ...

> been able to pin it on anything yet.
> NeilBrown

I _had_ problems with the previous kernel (same version, same config, 
different (older) compiler (gcc 3.4.5 instead of 4.1.2), on both client and server)
It would randomly (usually within 30 mins) 'lock up' NFS, where the client
sends out requests but doesn't get any answer (apart from tcp-ack) from the 
server. Only a forced umount/remount recovered that (until the next lock-up). 
But I'm willing to attribute that to a somehow broken gcc.

again, thanks for commenting.

bye,
Thorsten
 
> --- linux-2.6.orig/net/sunrpc/svcsock.c
> +++ linux-2.6/net/sunrpc/svcsock.c
> @@ -779,7 +779,7 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
>  	}
>  
>  	clear_bit(SK_DATA, &svsk->sk_flags);
> -	while ((err == kernel_recvmsg(svsk->sk_sock, &msg, NULL,
> +	while ((err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
>  				      0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
>  	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
>  		if (err == -EAGAIN) {
> 
> 
> > 
> > Mar 16 16:57:06 Marvin kernel: svc: bad direction 268435456, dropping request
> > Mar 16 17:58:19 Marvin kernel: svc: bad direction 268435456, dropping request
> > Mar 16 19:55:49 Marvin kernel: svc: bad direction 268435456, dropping request
> > ...
> > Mar 17 04:30:03 Marvin kernel: svc: bad direction 268435456, dropping request

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
