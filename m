Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbZD1OiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbZD1OiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZD1OiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:38:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53991
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755685AbZD1OiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:38:08 -0400
Date: Tue, 28 Apr 2009 07:37:59 -0700 (PDT)
Message-Id: <20090428.073759.78537345.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: mingo@elte.hu, dada1@cosmosbay.com, torvalds@linux-foundation.org,
       shemminger@vyatta.com, zbr@ioremap.net, peterz@infradead.org,
       jarkao2@gmail.com, paulus@samba.org, paulmck@linux.vnet.ibm.com,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090428135219.GA28513@Krystal>
References: <20090428124033.GA1655@elte.hu>
	<20090428.064340.193569214.davem@davemloft.net>
	<20090428135219.GA28513@Krystal>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Tue, 28 Apr 2009 09:52:19 -0400

> The local_bh_disable() could be outside of the locking construct. This
> would make it easier to adapt it to various users (irq disable, bh
> disable, preempt disable) depending on the contexts from which they much
> be protected.
> 
> And if it still does not work for some reason, using a #define is
> discouraged, but could work.

That's what I was hoping to avoid, things like macros and having
the callers of this thing expand the two parts of the operation.

What's the point in making this generic if it ends up being ugly
as hell?
