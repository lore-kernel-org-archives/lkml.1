Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbZDQIHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbZDQIHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZDQIHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:07:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40446
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbZDQIHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:07:19 -0400
Date: Fri, 17 Apr 2009 01:07:10 -0700 (PDT)
Message-Id: <20090417.010710.59150850.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: dada1@cosmosbay.com, shemminger@vyatta.com, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090417054032.GD6885@linux.vnet.ibm.com>
References: <20090416215033.3e648a7a@nehalam>
	<49E810B0.9000906@cosmosbay.com>
	<20090417054032.GD6885@linux.vnet.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Apr 2009 22:40:32 -0700

> I completely agree that this RCU is absolutely -not- 2.6.30 material.  ;-)

I don't understand why we're writing such complicated code.

Oh I see why, it's because not every arch uses the generic SMP helpers
yet :-)

Because if they did universally, we could solve this problem so
simply, by merely sending a remote softirq to every online cpu.  Once
those all complete we have enough of a quiesce period, every cpu must
have exited any netfilter packet processing code path they were in.

And we could know they complete using an atomic counter or something.
