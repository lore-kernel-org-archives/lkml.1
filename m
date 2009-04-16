Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZDPAGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZDPAGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZDPAFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:05:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37276
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753037AbZDPAFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:05:48 -0400
Date: Wed, 15 Apr 2009 17:05:39 -0700 (PDT)
Message-Id: <20090415.170539.34899625.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: dada1@cosmosbay.com, kaber@trash.net, jeff.chua.linux@gmail.com,
       paulmck@linux.vnet.ibm.com, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090415170111.6e1ca264@nehalam>
References: <49E64C91.5020708@cosmosbay.com>
	<20090415.164811.19905145.davem@davemloft.net>
	<20090415170111.6e1ca264@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 15 Apr 2009 17:01:11 -0700

> The counters are the bigger problem, otherwise we could just free table
> info via rcu.  Do we really have to support: replace where the counter
> values coming out to user space are always exactly accurate, or is it
> allowed to replace a rule and maybe lose some counter ticks (worst case
> NCPU-1).

I say this case doesn't matter until someone can prove that it's
any different from the IPTABLES replace operation system call
executing a few microseconds earlier or later.

There really is no difference, and we're making complexity out of
nothing just to ensure something which isn't actually guarenteed right
now.
