Return-Path: <linux-kernel-owner+w=401wt.eu-S934165AbZDBUSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbZDBUSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbZDBUSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:18:39 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50960 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbZDBUSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:18:38 -0400
Message-ID: <49D51D86.9030906@cosmosbay.com>
Date: Thu, 02 Apr 2009 22:18:14 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>,
       Rusty Russell <rusty@rustcorp.com.au>, coreteam@netfilter.org
Subject: Re: [netfilter bug] BUG: using smp_processor_id() in preemptible
 [00000000] code: ssh/9115, caller is ipt_do_table+0xc8/0x559
References: <20090402200128.GA21805@elte.hu>
In-Reply-To: <20090402200128.GA21805@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 02 Apr 2009 22:18:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> Not sure whether this bug has been reported before (a quick subject 
> search on netdev and lkml suggests that it's not):
> 
> i switched over -tip to latest -git an hour ago (it was on a v2.6.29 
> base before that), and one of my testboxes started emitting lots of 
> these warnings:


Hi Ingo

David put into its tree fix for that a few hours ago

commit fa9a86ddc8ecd2830a5e773facc250f110300ae7

(netfilter: iptables: lock free counters) forgot to disable BH
in arpt_do_table(), ipt_do_table() and  ip6t_do_table()

Use rcu_read_lock_bh() instead of rcu_read_lock() cures the problem.

Reported-and-bisected-by: Roman Mindalev <r000n@r000n.net>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>


Should be pushed to Linus in next round

Thank you

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=fa9a86ddc8ecd2830a5e773facc250f110300ae7


