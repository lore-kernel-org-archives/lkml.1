Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbXJKDK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbXJKDK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 23:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXJKDKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 23:10:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37471 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756341AbXJKDKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 23:10:13 -0400
Date: Wed, 10 Oct 2007 20:10:08 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dino@in.ibm.com, cpw@sgi.com, menage@google.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       nickpiggin@yahoo.com.au, mingo@elte.hu
Subject: Re: [PATCH v2] cpuset sched_load_balance flag
Message-Id: <20071010201008.50854faf.pj@sgi.com>
In-Reply-To: <20071010192957.78d3668f.akpm@linux-foundation.org>
References: <20071006094747.17518.44098.sendpatchset@jackhammer.engr.sgi.com>
	<20071010192957.78d3668f.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
> > +		*doms = top_cpuset.cpus_allowed;
> 
> We generally only excuse failure to check kmalloc return value when the
> code is called on the bootup path.  But this code is called at other times.
> 
> >
> > ...
> > +	doms_cur =  kmalloc(sizeof(cpumask_t), GFP_KERNEL);

Ah - good catch - thanks, Andrew.  I should put together a fix,
to check these kmalloc calls.

For rebuild_sched_domains(), this can mean we just up and return having
done nothing.

For arch_init_sched_domains(), the code calling arch_init_sched_domains()
is not checking for failure, and doesn't have a trivial fallback code
path in the case of failure.  I'll have to think about that one just a
little.

Thanks, Andrew!

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
