Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZKJXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZKJXGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbZKJXGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:06:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1323 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZKJXGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:06:16 -0500
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
 functions
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20091110225926.GA8424@linux.vnet.ibm.com>
References: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org>
	 <1257892710.25443.9.camel@Joe-Laptop.home>
	 <20091110225926.GA8424@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 15:06:20 -0800
Message-ID: <1257894380.25443.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 14:59 -0800, Paul E. McKenney wrote:
> > non-inline functions in .h files probably aren't a good idea.
> ;-)
> Here are my options:
[]
> Please note that kernel/rcutree_plugin.h is internal to RCU -- only
> kernel/rcutree.c includes it, so there is no possibility of conflicting
> definitions.
> 
> Any options that I am missing?

Maybe something like:

#ifdef whatever
#define RCU_ANNOUNCE "Hierarchical RCU implementation.\n"
...
#else
#define RCU_ANNOUNCE "Experimental preemptable hierarchical RCU implementation.\n"
...
#endif

Use pr_info(RCU_ANNOUNCE) instead of rcu_bootup_announce();

?

