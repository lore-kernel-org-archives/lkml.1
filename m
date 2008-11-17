Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbYKQVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbYKQVJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYKQVFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:05:00 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:47081 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYKQVEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:04:54 -0500
Message-ID: <4921DC61.4000702@cosmosbay.com>
Date: Mon, 17 Nov 2008 22:04:33 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: skb_release_head_state(): Re: [Bug #11308] tbench regression
 on	each kernel release from 2.6.22 -&gt; 2.6.28
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117205530.GE12020@elte.hu>
In-Reply-To: <20081117205530.GE12020@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 22:04:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> (gdb) list *0xffffffff8048942e
> 0xffffffff8048942e is in skb_release_head_state (include/linux/skbuff.h:1783).
> 1778	}
> 1779	#endif
> 1780	#ifdef CONFIG_BRIDGE_NETFILTER
> 1781	static inline void nf_bridge_put(struct nf_bridge_info *nf_bridge)
> 1782	{
> 1783		if (nf_bridge && atomic_dec_and_test(&nf_bridge->use))
> 1784			kfree(nf_bridge);
> 1785	}
> 1786	static inline void nf_bridge_get(struct nf_bridge_info *nf_bridge)
> 1787	{
> 
> and ouch does that global dec on &nf_bridge->use hurt!
> 
> i do have:
> 
>   CONFIG_BRIDGE_NETFILTER=y
> 
> (this is a Fedora distro kernel derived .config)

Hum, you also should hit this cache line at atomic_inc() site then...

Strange, I never caught this one.

