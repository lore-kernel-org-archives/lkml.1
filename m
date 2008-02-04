Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYBDKyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYBDKyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYBDKyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:54:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33478 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750743AbYBDKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:54:35 -0500
Date: Mon, 4 Feb 2008 04:54:29 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU
 isolation extensions]
Message-Id: <20080204045429.7738c25c.pj@sgi.com>
In-Reply-To: <47A6AABD.7080006@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
	<1201511305.6149.30.camel@lappy>
	<20080128085910.7d38e9f5.pj@sgi.com>
	<479E20DA.2080403@qualcomm.com>
	<20080128130637.60db148e.pj@sgi.com>
	<47A21C53.2010502@qualcomm.com>
	<20080202001612.98354ff2.pj@sgi.com>
	<47A557E3.4080206@qualcomm.com>
	<20080203015315.6053d3dd.pj@sgi.com>
	<47A6AABD.7080006@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Looks like I failed to explain what I'm trying to achieve. So let me try again.

Well done.  I read through that, expecting to disagree or at least
to not understand at some point, and got all the way through nodding
my head in agreement.  Good.

Whether the earlier confusions were lack of clarity in the presentation,
or lack of competence in my brain ... well guess I don't want to ask that
question ;).

Well ... just one minor point:

Max wrote in reply to pj:
> > The cpu_isolated_map is a file static variable known only within
> > the kernel/sched.c file; this should not change.
> I completely disagree. In fact I think all the cpu_xxx_map (online, present, isolated)
> variables do not belong in the scheduler code. I'm thinking of submitting a patch that
> factors them out into kernel/cpumask.c We already have cpumask.h.

Huh?  Why would you want to do that?

    For one thing, the map being discussed here, cpu_isolated_map,
    is only used in sched.c, so why publish it wider?

    And for another thing, we already declare externs in cpumask.h for
    the other, more widely used, cpu_*_map variables cpu_possible_map,
    cpu_online_map, and cpu_present_map.

Other than that detail, we seem to be communicating and in agreement on
your first item, isolating CPU scheduler load balancing.  Good.

On your other two items, irq and workqueue isolation, which I had
suggested doing via cpuset sched_load_balance, I now agree that that
wasn't a good idea.

I am still a little surprised at using isolation extensions to
disable irqs on select CPUs; but others have thought far more about
irqs than I have, so I'll be quiet.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
