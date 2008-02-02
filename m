Return-Path: <linux-kernel-owner+w=401wt.eu-S1763928AbYBBGNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763928AbYBBGNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 01:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYBBGNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 01:13:34 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55803 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbYBBGNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 01:13:33 -0500
Date: Sat, 2 Feb 2008 00:16:12 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU
 isolation extensions]
Message-Id: <20080202001612.98354ff2.pj@sgi.com>
In-Reply-To: <47A21C53.2010502@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
	<1201511305.6149.30.camel@lappy>
	<20080128085910.7d38e9f5.pj@sgi.com>
	<479E20DA.2080403@qualcomm.com>
	<20080128130637.60db148e.pj@sgi.com>
	<47A21C53.2010502@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Here is the list of things of issues with sched_load_balance flag from CPU isolation 
> perspective:

A separate thread happened to start up on lkml.org, shortly after
yours, that went into this in considerable detail.

For example, the interaction of cpusets, sched_load_balance,
sched_domains and real time scheduling is examined in some detail on
this thread.  Everyone participating on that thread learned something
(we all came into it with less than a full picture of what's there.)

I would encourage you to read it closely.  For example, the scheduler
code should not be trying to access per-cpuset attributes such as
the sched_load_balance flag (you are correct that this would be
difficult to do because of the locking; however by design, that is
not to be done.)

This thread begins at:

    scheduler scalability - cgroups, cpusets and load-balancing
    http://lkml.org/lkml/2008/1/29/60

Too bad we didn't think to include you in the CC list of that
thread from the beginning.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
