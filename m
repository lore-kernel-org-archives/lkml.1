Return-Path: <linux-kernel-owner+w=401wt.eu-S933110AbZD1RGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbZD1RGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932880AbZD1RCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:02:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932879AbZD1RCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:02:40 -0400
Date: Tue, 28 Apr 2009 09:50:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Hemminger <shemminger@vyatta.com>
cc: David Miller <davem@davemloft.net>, mathieu.desnoyers@polymtl.ca,
       mingo@elte.hu, dada1@cosmosbay.com, zbr@ioremap.net,
       peterz@infradead.org, jarkao2@gmail.com, paulus@samba.org,
       paulmck@linux.vnet.ibm.com, kaber@trash.net, jeff.chua.linux@gmail.com,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: revised locking for x_tables
In-Reply-To: <20090428092411.5331c4a1@nehalam>
Message-ID: <alpine.LFD.2.00.0904280931360.22156@localhost.localdomain>
References: <20090428135219.GA28513@Krystal> <20090428.073759.78537345.davem@davemloft.net> <20090428144920.GA28942@Krystal> <20090428.080031.14741305.davem@davemloft.net> <20090428092411.5331c4a1@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ack. 

It could do with the update from Eric about how non-current CPU writelocks 
only require preemp-disable around get_counters() (and then the 
local_bh_disable() only around the current-CPU case).

I _think_ get_counters() is the only case that can use that optimization, 
but it's quite possible that it's worth doing especially for machines with 
lots of cores, if BH latency is an issue (and it might be).

Of course, for the lots-and-lots of cores case, even the preemption 
disable might be an issue. And then it really does get much more 
complicated. At that point, you probably want the RCU thing.

			Linus			
