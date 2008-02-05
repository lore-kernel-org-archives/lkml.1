Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYBECrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYBECrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYBECq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:46:56 -0500
Received: from relay2.sgi.com ([192.48.171.30]:54172 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751465AbYBECqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:46:55 -0500
Date: Mon, 4 Feb 2008 20:46:50 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU
 isolation extensions]
Message-Id: <20080204204650.1385ae3e.pj@sgi.com>
In-Reply-To: <47A79D73.7080402@qualcomm.com>
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
	<20080204045429.7738c25c.pj@sgi.com>
	<47A79D73.7080402@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> >     And for another thing, we already declare externs in cpumask.h for
> >     the other, more widely used, cpu_*_map variables cpu_possible_map,
> >     cpu_online_map, and cpu_present_map.
> Well, to address #2 and #3 isolated map will need to be exported as well.
> Those other maps do not really have much to do with the scheduler code.
> That's why I think either kernel/cpumask.c or kernel/cpu.c is a better place for them.

Well, if you have need it to be exported for #2 or #3, then that's ok
by me - export it.

I'm unaware of any kernel/cpumask.c.  If you meant lib/cpumask.c, then
I'd prefer you not put it there, as lib/cpumask.c just contains the
implementation details of the abstract data type cpumask_t, not any of
its uses.  If you mean kernel/cpuset.c, then that's not a good choice
either, as that just contains the implementation details of the cpuset
subsystem.  You should usually define such things in one of the files
using it, and unless there is clearly a -better- place to move the
definition, it's usually better to just leave it where it is.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
