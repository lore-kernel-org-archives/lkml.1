Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYHKSrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYHKSrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYHKSqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:46:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33862 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYHKSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:46:55 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5358"; a="5317170"
Message-ID: <48A08920.5040208@qualcomm.com>
Date: Mon, 11 Aug 2008 11:46:56 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jeff.chua.linux@gmail.com,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com> <20080811181642.GS4524@elte.hu> <48A084C8.6050204@qualcomm.com> <20080811183814.GA12788@elte.hu>
In-Reply-To: <20080811183814.GA12788@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>>> This will need some test time on 32-bit as that is where this 
>>> represents a material change. ( albeit what matters most is the 
>>> maxcpus=1 distinction - and for that nosmp can be used as well to 
>>> turn off multi-cpu support altogether. So we could do this in 
>>> v2.6.27 as well. )
>> So far we got a couple of reports that it works as expected on 32 
>> (both laptop and server/desktop).
> 
> Yes, but the usecase i'm worried about is when say maxcpus=1 was used to 
> _prevent_ an SMP bootup - because the system would not work otherwise.
> 
> i guess we want to tickle those systems anyway as that case is not 
> supposed to happen (and it can always be totally disabled via nosmp or 
> noapic).
> 
> So i'm not against your fix/change per se, i just wanted to highlight 
> that it has some impact on existing uses of maxcpus that is outside of 
> your cpu-hotplug usecase.

I see what you mean. I think it's fairly safe though since we do not actually
do much for the cpus that are not going to be brought online. Mainly just
setting cpu_*_map and initializing per cpu areas. If something is broken in
there we'd probably want to fix that asap anyway. And like you said nosmp does
the job too.

Max
