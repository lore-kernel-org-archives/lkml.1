Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZDMTdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZDMTdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZDMTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:33:43 -0400
Received: from host91-201.netintact.se ([194.153.91.201]:47945 "EHLO
	wlug.westbo.se" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZDMTdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:33:43 -0400
X-Greylist: delayed 1645 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 15:33:42 EDT
Date: Mon, 13 Apr 2009 21:06:10 +0200 (CEST)
From: Martin Josefsson <gandalf@mjufs.se>
X-X-Sender: gandalf@wlug.westbo.se
To: Stephen Hemminger <shemminger@vyatta.com>
cc: paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       paulus@samba.org, mingo@elte.hu, torvalds@linux-foundation.org,
       laijs@cn.fujitsu.com, jeff.chua.linux@gmail.com, dada1@cosmosbay.com,
       jengelh@medozas.de, kaber@trash.net, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU
In-Reply-To: <20090413095309.631cf395@nehalam>
Message-ID: <Pine.LNX.4.62.0904132102030.10428@wlug.westbo.se>
References: <20090411174801.GG6822@linux.vnet.ibm.com>
 <18913.53699.544083.320542@cargo.ozlabs.ibm.com> <20090412173108.GO6822@linux.vnet.ibm.com>
 <20090412.181330.23529546.davem@davemloft.net> <20090413040413.GQ6822@linux.vnet.ibm.com>
 <20090413095309.631cf395@nehalam>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009, Stephen Hemminger wrote:

> This is an alternative version of ip/ip6/arp tables locking using
> per-cpu locks.  This avoids the overhead of synchronize_net() during
> update but still removes the expensive rwlock in earlier versions.
>
> The idea for this came from an earlier version done by Eric Duzamet.
> Locking is done per-cpu, the fast path locks on the current cpu
> and updates counters.  The slow case involves acquiring the locks on
> all cpu's.

Doesn't spin_lock() result in a pipeline flush on x86?

iirc there was a benchmark in an RCU paper that tested using per cpu 
spin_locks and the result was that it didn't scale well at all.

/Martin
