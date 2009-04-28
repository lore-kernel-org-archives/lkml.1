Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbZD1NoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbZD1NoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbZD1Nnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:43:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57264
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbZD1Nnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:43:46 -0400
Date: Tue, 28 Apr 2009 06:43:40 -0700 (PDT)
Message-Id: <20090428.064340.193569214.davem@davemloft.net>
To: mingo@elte.hu
Cc: dada1@cosmosbay.com, torvalds@linux-foundation.org, shemminger@vyatta.com,
       zbr@ioremap.net, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jarkao2@gmail.com, paulus@samba.org, paulmck@linux.vnet.ibm.com,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090428124033.GA1655@elte.hu>
References: <49F6A8FD.3010804@cosmosbay.com>
	<20090428.045342.206106171.davem@davemloft.net>
	<20090428124033.GA1655@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 28 Apr 2009 14:40:33 +0200

> IMHO this locking construct should be considered for 
> linux/local_lock.h and kernel/local_lock.c. Even if the netfilter 
> code drops its use soon afterwards ;-)

If you can show me have to pass a per-cpu variable (the variable,
not a dereference of it) as an argument to an inline function,
I'll implement this :-)

It has to be dereferenced after local_bh_disable() for the
read side acquisition.
