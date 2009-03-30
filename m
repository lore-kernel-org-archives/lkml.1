Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZC3O4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZC3O4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZC3O42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:56:28 -0400
Received: from mail.vyatta.com ([76.74.103.46]:55917 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZC3O41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:56:27 -0400
Date: Mon, 30 Mar 2009 07:56:19 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Roman Mindalev <r000n@r000n.net>, Eric Dumazet <dada1@cosmosbay.com>,
       LKML <linux-kernel@vger.kernel.org>, netfilter@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression caused by commit "netfilter: iptables: lock free
 counters"
Message-ID: <20090330075619.23677280@nehalam>
In-Reply-To: <49D0B628.5000501@trash.net>
References: <20090329234702.4988017f@desktop.r000n.info>
	<49D075A3.1050202@cosmosbay.com>
	<20090330145031.2dfd854e@desktop.r000n.info>
	<49D0B628.5000501@trash.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 14:08:08 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Roman Mindalev wrote:
> > On Mon, 30 Mar 2009 09:32:51 +0200
> > Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> >> Could you try following patch ?
> >>
> >> [PATCH] netfilter: use rcu_read_bh() in ipt_do_table()
> >>
> >> Commit 784544739a25c30637397ace5489eeb6e15d7d49
> >> (netfilter: iptables: lock free counters) forgot to disable BH
> >> in arpt_do_table(), ipt_do_table() and  ip6t_do_table()
> >>
> >> Use rcu_read_lock_bh() instead of rcu_read_lock() cures the problem.
> >>
> >> Reported-and-bisected-by: Roman Mindalev <r000n@r000n.net>
> >> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> >> ---
> > 
> > 2.6.29-git4 and 2.6.29-git6 both works fine for me with this patch. 
> > Thanks, Eric!
> 
> Thanks indeed Eric :) Dave, please apply.
> 
> Acked-by: Patrick McHardy <kaber@trash.net>
> 
> 
Acked-by: Stephen Hemminger <shemminger@vyatta.com>

The original version had rcu_read_lock_bh() but someone (not sure who)
talked me into removing it.
