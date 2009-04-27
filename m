Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbZD0U4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbZD0U4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZD0U4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:56:10 -0400
Received: from cs-studio.ru ([195.178.208.66]:58603 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935AbZD0U4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:56:09 -0400
Date: Tue, 28 Apr 2009 00:56:02 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       davem@davemloft.net, dada1@cosmosbay.com, jeff.chua.linux@gmail.com,
       paulus@samba.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, benh@kernel.crashing.org
Subject: Re: [PATCH RFC] v2 expedited "big hammer" RCU grace periods
Message-ID: <20090427205601.GA5716@ioremap.net>
References: <20090426052340.GA24931@linux.vnet.ibm.com> <20090426112717.GE10391@elte.hu> <20090426191343.GC29238@Krystal> <20090426202255.GA5365@elte.hu> <20090426214451.GC6945@linux.vnet.ibm.com> <20090427032639.GA10087@elte.hu> <20090427132153.GI6945@linux.vnet.ibm.com> <20090427155424.GA27041@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427155424.GA27041@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Apr 27, 2009 at 11:54:24AM -0400, Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> It might sound a bit simplistic, but... scheduling a high-priority
> workqueue on every CPUs would give you the guarantees you seem to need
> here. Or is the delay of letting the scheduler schedule a high-priority
> task a delay you are trying to avoid ?

I believe not the abstract (empty) task should be invoked, but a real
task which does the work. Presumably if we want to schedule a way
networking part to copy its counters, system should wake up the
appropriate userspace thread blocked in a grace-period waking path, so
effectively either RCU callback processing code or some registered
thread should be awakened.

Just a detail though.

-- 
	Evgeniy Polyakov
