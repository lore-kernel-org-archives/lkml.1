Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZDTWmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZDTWmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbZDTWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:41:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60546 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499AbZDTWls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:41:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18924.64032.103954.171918@cargo.ozlabs.ibm.com>
Date: Tue, 21 Apr 2009 08:41:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, torvalds@linux-foundation.org,
       jeff.chua.linux@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v10)
In-Reply-To: <20090420215827.GK6822@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>
	<49E72E83.50702@trash.net>
	<20090416.153354.170676392.davem@davemloft.net>
	<20090416234955.GL6924@linux.vnet.ibm.com>
	<20090417012812.GA25534@linux.vnet.ibm.com>
	<20090418094001.GA2369@ioremap.net>
	<20090418141455.GA7082@linux.vnet.ibm.com>
	<20090420103414.1b4c490f@nehalam>
	<49ECBE0A.7010303@cosmosbay.com>
	<18924.59347.375292.102385@cargo.ozlabs.ibm.com>
	<20090420215827.GK6822@linux.vnet.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney writes:

> But a single CPU is acquiring one lock per CPU, so all the increments
> are to one CPU's preempt_count.  :-(

OK, I see, so a task can't take more than 255 spinlocks without
overflowing the preempt count, which seems a bit limiting.

There are 6 free bits in the preempt_count currently, so the preempt
count could be expanded to 14 bits, which would be enough for all
current systems.  Beyond that I guess we could make preempt_count be a
long and allow bigger counts on 64-bit architectures.

Paul.
