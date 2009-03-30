Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZC3MIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZC3MIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZC3MIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:08:12 -0400
Received: from stinky.trash.net ([213.144.137.162]:59440 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZC3MIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:08:11 -0400
Message-ID: <49D0B628.5000501@trash.net>
Date: Mon, 30 Mar 2009 14:08:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Roman Mindalev <r000n@r000n.net>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       LKML <linux-kernel@vger.kernel.org>, netfilter@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression caused by commit "netfilter: iptables: lock free counters"
References: <20090329234702.4988017f@desktop.r000n.info>	<49D075A3.1050202@cosmosbay.com> <20090330145031.2dfd854e@desktop.r000n.info>
In-Reply-To: <20090330145031.2dfd854e@desktop.r000n.info>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Mindalev wrote:
> On Mon, 30 Mar 2009 09:32:51 +0200
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Could you try following patch ?
>>
>> [PATCH] netfilter: use rcu_read_bh() in ipt_do_table()
>>
>> Commit 784544739a25c30637397ace5489eeb6e15d7d49
>> (netfilter: iptables: lock free counters) forgot to disable BH
>> in arpt_do_table(), ipt_do_table() and  ip6t_do_table()
>>
>> Use rcu_read_lock_bh() instead of rcu_read_lock() cures the problem.
>>
>> Reported-and-bisected-by: Roman Mindalev <r000n@r000n.net>
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>> ---
> 
> 2.6.29-git4 and 2.6.29-git6 both works fine for me with this patch. 
> Thanks, Eric!

Thanks indeed Eric :) Dave, please apply.

Acked-by: Patrick McHardy <kaber@trash.net>


