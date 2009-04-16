Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZDPWeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZDPWeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 18:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZDPWeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 18:34:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38938
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbZDPWeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 18:34:04 -0400
Date: Thu, 16 Apr 2009 15:33:54 -0700 (PDT)
Message-Id: <20090416.153354.170676392.davem@davemloft.net>
To: kaber@trash.net
Cc: torvalds@linux-foundation.org, shemminger@vyatta.com, dada1@cosmosbay.com,
       jeff.chua.linux@gmail.com, paulmck@linux.vnet.ibm.com, paulus@samba.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <49E72E83.50702@trash.net>
References: <20090415170111.6e1ca264@nehalam>
	<alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>
	<49E72E83.50702@trash.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 16 Apr 2009 15:11:31 +0200

> Linus Torvalds wrote:
>> On Wed, 15 Apr 2009, Stephen Hemminger wrote:
>>> The counters are the bigger problem, otherwise we could just free
>>> table
>>> info via rcu.  Do we really have to support: replace where the counter
>>> values coming out to user space are always exactly accurate, or is it
>>> allowed to replace a rule and maybe lose some counter ticks (worst
>>> case
>>> NCPU-1).
>> Why not just read the counters fromt he old one at RCU free time (they
>> are guaranteed to be stable at that point, since we're all done with
>> those entries), and apply them at that point to the current setup?
> 
> We need the counters immediately to copy them to userspace, so waiting
> for an asynchronous RCU free is not going to work.

It just occurred to me that since all netfilter packet handling
goes through one place, we could have a sort-of "netfilter RCU"
of sorts to solve this problem.
