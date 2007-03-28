Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXC1CUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXC1CUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXC1CUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:20:07 -0400
Received: from ns1.suse.de ([195.135.220.2]:42228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112AbXC1CUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:20:05 -0400
From: Neil Brown <neilb@suse.de>
To: dl8bcu@dl8bcu.de
Date: Wed, 28 Mar 2007 12:19:52 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17929.53448.506302.615732@notabene.brown>
Cc: Phy Prabab <phyprabab@gmail.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Odd log message associated with NFS
In-Reply-To: message from Thorsten Kranzkowski on Tuesday March 27
References: <2fe399760703271140l703c2791oa84e9e1832487dcb@mail.gmail.com>
	<20070327193909.GA585@ds20.borg.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday March 27, dl8bcu@dl8bcu.de wrote:
> On Tue, Mar 27, 2007 at 11:40:48AM -0700, Phy Prabab wrote:
> > Hello,
> > 
> > I am currently running 2.6.21-rc5 and I am seeing quite a bit of this
> > message in my log files:
> > kernel: rpcsvc: received unknown control message:-2144992132/-1
> > 
> > This machine is an dual dual core opteron with 3Ware 9650 (14 disk
> > RAID10), 4G RAM, 64bit kernel, nfsutils-1.0.12 running knfsd.  This
> > machine is a  file server.
> 
> Just a 'me, too':

For the 'unknown control message' messages,
see:   "fix typo in svc_udp_recvfrom"  previously on
nfs@lists.sourceforge.net.

Fix is in -mm and below.

For "svc: bad direction" .... Don't know... garbage on the net maybe?
Or maybe not.  I have seen something like that before, but haven't
been able to pin it on anything yet.
NeilBrown


--- linux-2.6.orig/net/sunrpc/svcsock.c
+++ linux-2.6/net/sunrpc/svcsock.c
@@ -779,7 +779,7 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	}
 
 	clear_bit(SK_DATA, &svsk->sk_flags);
-	while ((err == kernel_recvmsg(svsk->sk_sock, &msg, NULL,
+	while ((err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
 				      0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
 	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
 		if (err == -EAGAIN) {


> 
> Mar 16 16:57:06 Marvin kernel: svc: bad direction 268435456, dropping request
> Mar 16 17:58:19 Marvin kernel: svc: bad direction 268435456, dropping request
> Mar 16 19:55:49 Marvin kernel: svc: bad direction 268435456, dropping request
> ...
> Mar 17 04:30:03 Marvin kernel: svc: bad direction 268435456, dropping request
> Mar 17 06:28:52 Marvin kernel: pppd(795): unaligned trap at 0000020000207f90: 000000011fd8d33d 29 1
> Mar 17 06:28:55 Marvin kernel: inet_sk_reselect_saddr(): shifting inet->saddr from 82.149.xxx.xxx to 89.166.xxx.xxx
> Mar 17 09:05:21 Marvin kernel: rpcsvc: received unknown control message:-1024/186028080
> Mar 17 14:17:04 Marvin kernel: rpcsvc: received unknown control message:-1024/186028040
> Mar 17 14:17:31 Marvin kernel: rpcsvc: received unknown control message:-1024/186028040
> Mar 17 14:49:14 Marvin kernel: rpcsvc: received unknown control message:-1024/186028080
> Mar 17 14:49:15 Marvin kernel: rpcsvc: received unknown control message:-1024/186028040
> 
> 
> 
> This is from my little 'server', alpha ev4 'noname', 2.6.21-rc3, compiled 
> with gcc 4.1.2
> 
> client is mostly an alpha ev6 2.6.21-rc3, gcc 4.1.2.
> 
> Apart from the messages NFS seems to run just fine currently.
> 
> Bye,
> Thorsten 
> 
> 
> 
> -- 
> | Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
> | Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
> | Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
