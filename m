Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbZD1Lyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbZD1Lyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZD1Lxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:53:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53299
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760381AbZD1Lxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:53:49 -0400
Date: Tue, 28 Apr 2009 04:53:42 -0700 (PDT)
Message-Id: <20090428.045342.206106171.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: torvalds@linux-foundation.org, shemminger@vyatta.com, zbr@ioremap.net,
       mingo@elte.hu, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jarkao2@gmail.com, paulus@samba.org, paulmck@linux.vnet.ibm.com,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
From: David Miller <davem@davemloft.net>
In-Reply-To: <49F6A8FD.3010804@cosmosbay.com>
References: <alpine.LFD.2.00.0904271525120.22156@localhost.localdomain>
	<alpine.LFD.2.00.0904271602390.22156@localhost.localdomain>
	<49F6A8FD.3010804@cosmosbay.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 28 Apr 2009 08:58:05 +0200

> I am not sure my day job will permit me to polish a patch mixing all
> the bits and comments. But I am glad we eventually got back spinlocks
> which are probably better than rwlocks for implementing this stuff.
> 
> Instead of submitting a full patch again, we could first submit a new
>  include file containg all comments and inline functions ?
> 
> This include file could be local to netfilter, with a big stick on
> it to forbids its use on other areas (No changes in Documentation/ )
> 
> Then, as soon as we can go back to pure RCU solution, we can safely
> delete this controversial-locking-nesting-per-cpu-thing ?

I say we merge Linus's locking idea into the XV patch, fixup the
commit message wording, and move on with life.

For something that's going to get deleted as soon as the faster grace
period RCU stuff is available, it has consumed an inordinate amount of
our time :-)

I might take a stab at this before hittng bed tonight, no promises :)
