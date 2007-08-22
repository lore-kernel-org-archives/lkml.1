Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbXHVUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbXHVUaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbXHVUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:30:03 -0400
Received: from 1wt.eu ([62.212.114.60]:2256 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760093AbXHVUaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:30:00 -0400
Date: Wed, 22 Aug 2007 22:16:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Message-ID: <20070822201634.GB14132@1wt.eu>
References: <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com> <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au> <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil> <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil> <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au> <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com> <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au> <6bffcb0e0708220946hc2943f5jdb33215cdfab08d1@mail.gmail.com> <6bffcb0e0708221050s68975158k7a3b27c7c30f455d@mail.gmail.com> <1187810114.1451.453.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187810114.1451.453.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 03:15:14PM -0400, Stephen Smalley wrote:
> On Wed, 2007-08-22 at 19:50 +0200, Michal Piotrowski wrote:
> > On 22/08/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > On 22/08/07, James Morris <jmorris@namei.org> wrote:
> > [snip]
> > > > The previous problem is theoretically unrelated.  It arose via a separate
> > > > mechanism which can't be used at the same as the one you're seeing now in
> > > > the logs.
> > > >
> > > > So this either looks like a problem which has gone unnoticed and was
> > > > inadvertently fixed at some point, or is unique to the 2.6.20 stable
> > > > series.
> > >
> > > Yup, it is very interesting why no one noticed it. Binary search in progress:
> > > good - 2.6.20.4
> > > bad - 2.6.20.8
> > 
> > Ok, I narrowed the problem to 2.6.20.7. There are a few net changes
> > http://eu.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.7
> > any suggestions?
> > 
> > I also have seen this avc on 2.6.20.6 during reboot
> > 
> > [ 2333.905944] audit(1187803699.273:271): avc:  denied  { send } for
> > saddr=192.168.1.70 src=48591 daddr=72.14.217.189 dest=80 netif=eth0
> > scontext=user_u:system_r:unconfined_t:s0
> > tcontext=system_u:system_r:kernel_t:s0 tclass=packet
> > [ 2334.420598] audit(1187803699.789:272): avc:  denied  { send } for
> > saddr=192.168.1.70 src=47248 daddr=66.249.91.18 dest=80 netif=eth0
> > scontext=user_u:system_r:unconfined_t:s0
> > tcontext=system_u:system_r:kernel_t:s0 tclass=packet
> > 
> > so the roots of the problem may lie between 2.6.20.4 and 2.6.20.6
> > 
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console2.log
> 
> Might be related to this:
> http://marc.info/?l=git-commits-head&m=118271540932264&w=2

Interesting, this one was fixed in 2.6.22-rc6, but is neither in 2.6.20
nor in 2.6.21. Michal, could you please try to apply the patch ? I include
it here for your convenience. If it fixes your problem, I can queue it for
next 2.6.20-stable, and forward it to the -stable team for 2.6.21 in case
Greg and Chris plan to release another one.


From: Patrick McHardy <kaber@trash.net>
Date: Sun, 24 Jun 2007 05:58:34 +0000 (-0700)
Subject: [SKBUFF]: Fix incorrect config #ifdef around skb_copy_secmark
X-Git-Tag: v2.6.22~103^2~6
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=dbbeb2f9917792b989b6269ebfe24257f9aa1618

[SKBUFF]: Fix incorrect config #ifdef around skb_copy_secmark

secmark doesn't depend on CONFIG_NET_SCHED.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7c6a34e..8d43ae6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -434,8 +434,8 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 	n->tc_verd = CLR_TC_MUNGED(n->tc_verd);
 	C(iif);
 #endif
-	skb_copy_secmark(n, skb);
 #endif
+	skb_copy_secmark(n, skb);
 	C(truesize);
 	atomic_set(&n->users, 1);
 	C(head);

Thanks,
Willy

