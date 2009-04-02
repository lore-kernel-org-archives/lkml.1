Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbZDBUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbZDBUX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761452AbZDBUXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:23:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55906 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490AbZDBUXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:23:08 -0400
Date: Thu, 2 Apr 2009 22:22:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>,
       Rusty Russell <rusty@rustcorp.com.au>, coreteam@netfilter.org
Subject: Re: [netfilter bug] BUG: using smp_processor_id() in preemptible
	[00000000] code: ssh/9115, caller is ipt_do_table+0xc8/0x559
Message-ID: <20090402202246.GA12191@elte.hu>
References: <20090402200128.GA21805@elte.hu> <49D51D86.9030906@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D51D86.9030906@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Ingo Molnar a écrit :
> > Not sure whether this bug has been reported before (a quick subject 
> > search on netdev and lkml suggests that it's not):
> > 
> > i switched over -tip to latest -git an hour ago (it was on a v2.6.29 
> > base before that), and one of my testboxes started emitting lots of 
> > these warnings:
> 
> 
> Hi Ingo
> 
> David put into its tree fix for that a few hours ago
> 
> commit fa9a86ddc8ecd2830a5e773facc250f110300ae7
> 
> (netfilter: iptables: lock free counters) forgot to disable BH
> in arpt_do_table(), ipt_do_table() and  ip6t_do_table()
> 
> Use rcu_read_lock_bh() instead of rcu_read_lock() cures the problem.
> 
> Reported-and-bisected-by: Roman Mindalev <r000n@r000n.net>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> Acked-by: Patrick McHardy <kaber@trash.net>
> Acked-by: Stephen Hemminger <shemminger@vyatta.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> Should be pushed to Linus in next round
> 
> Thank you
> 
> http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=fa9a86ddc8ecd2830a5e773facc250f110300ae7

Small request: it's useful to plain-text include such commits in 
such email replies - if the patch is not too large. http is not very 
helpful to reply to specifics and it's not very useful when i want 
toapply it either. I now have to go hunting for the latest tree :)

	Ingo
