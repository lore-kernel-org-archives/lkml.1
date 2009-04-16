Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZDPM22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZDPM22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZDPM2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:28:19 -0400
Received: from stinky.trash.net ([213.144.137.162]:54939 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZDPM2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:28:18 -0400
Message-ID: <49E7245B.10208@trash.net>
Date: Thu, 16 Apr 2009 14:28:11 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: shemminger@vyatta.com, dada1@cosmosbay.com, jeff.chua.linux@gmail.com,
       paulmck@linux.vnet.ibm.com, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
References: <49E64C91.5020708@cosmosbay.com>	<20090415.164811.19905145.davem@davemloft.net>	<20090415170111.6e1ca264@nehalam> <20090415.170539.34899625.davem@davemloft.net>
In-Reply-To: <20090415.170539.34899625.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Wed, 15 Apr 2009 17:01:11 -0700
> 
>> The counters are the bigger problem, otherwise we could just free table
>> info via rcu.  Do we really have to support: replace where the counter
>> values coming out to user space are always exactly accurate, or is it
>> allowed to replace a rule and maybe lose some counter ticks (worst case
>> NCPU-1).
> 
> I say this case doesn't matter until someone can prove that it's
> any different from the IPTABLES replace operation system call
> executing a few microseconds earlier or later.
> 
> There really is no difference, and we're making complexity out of
> nothing just to ensure something which isn't actually guarenteed right
> now.

Actually I believe it does work right now. Userspace maps the old
counter values to the replacement rules and the kernel adds them
up, so in the end we currently should always have accurate counters,
independant of the exact time when a replacement took place.

