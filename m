Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZDPAUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZDPAUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbZDPAUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbZDPAUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:20:14 -0400
Date: Wed, 15 Apr 2009 17:10:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Hemminger <shemminger@vyatta.com>
cc: David Miller <davem@davemloft.net>, dada1@cosmosbay.com, kaber@trash.net,
       jeff.chua.linux@gmail.com, paulmck@linux.vnet.ibm.com, paulus@samba.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
In-Reply-To: <20090415170111.6e1ca264@nehalam>
Message-ID: <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>
References: <49E5BDF7.8090502@trash.net> <20090415135526.2afc4d18@nehalam> <49E64C91.5020708@cosmosbay.com> <20090415.164811.19905145.davem@davemloft.net> <20090415170111.6e1ca264@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Stephen Hemminger wrote:
> 
> The counters are the bigger problem, otherwise we could just free table
> info via rcu.  Do we really have to support: replace where the counter
> values coming out to user space are always exactly accurate, or is it
> allowed to replace a rule and maybe lose some counter ticks (worst case
> NCPU-1).

Why not just read the counters fromt he old one at RCU free time (they are 
guaranteed to be stable at that point, since we're all done with those 
entries), and apply them at that point to the current setup?

			Linus
