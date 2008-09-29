Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYI2PDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYI2PDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYI2PDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:03:24 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:57448 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYI2PDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:03:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAKyI4EhMQWq+/2dsb2JhbACBYro0gWc
Date: Mon, 29 Sep 2008 11:03:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: fix unregister bug and reenter bug
Message-ID: <20080929150320.GA11245@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48E08B05.7030802@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:57:18 up 116 days, 19:37,  9 users,  load average: 0.47, 0.50,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

I'll have to nack this fix :

One fix I already posted makes sure every marker unregister callers call
synchronize_sched() _at some point_ before module unload. It thus makes
sure we can do batch unregistration without doing multiple
synchronize_sched calls.

Also, there is no need to do the synchronize_sched with the marker mutex
held. call_rcu_sched takes care of making sure the previous quiescent
state is over before calling kfree. This means that when we return from
the register/unregister functions, there may still be markers "in
flight" using the old markers. Again, why would it be a problem ?

Thanks,

Mathieu

P.S. : I'll send along the patches I am referring to. Ingo, those should
probably be merged if they are not in -tip already.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
