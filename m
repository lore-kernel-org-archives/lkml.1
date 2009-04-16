Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbZDPQVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbZDPQVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbZDPQVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:21:16 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:36109 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbZDPQVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:21:15 -0400
Message-ID: <49E75AB4.6030701@cosmosbay.com>
Date: Thu, 16 Apr 2009 18:20:04 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu recursive spinlock  (v6)
References: <49E5BDF7.8090502@trash.net> <20090415135526.2afc4d18@nehalam> <49E64C91.5020708@cosmosbay.com> <20090415.164811.19905145.davem@davemloft.net> <20090415170111.6e1ca264@nehalam> <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <20090415174551.529d241c@nehalam> <49E6BBA9.2030701@cosmosbay.com> <49E7384B.5020707@trash.net> <20090416144748.GB6924@linux.vnet.ibm.com> <49E75876.10509@cosmosbay.com>
In-Reply-To: <49E75876.10509@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 16 Apr 2009 18:20:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :

> I also considered using regular spinlocks and spin_trylock() to "detect"
> the recurse case without a global counter.
> 
> lock :
> local_bh_disable();
> int locked = spin_trylock(&__get_cpu_var(arp_tables_lock);
> 
> unlock:
> 
> if (likely(locked))
> 	spin_unlock(&__get_cpu_var(arp_tables_lock));
> local_bh_enable();
> 
> But we would lose some runtime features, I dont feel comfortable about
> this trylock version. What others people think ?
> 

Oh well, this wont work of course, forget about this trylock thing :)

