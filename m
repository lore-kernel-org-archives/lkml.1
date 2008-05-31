Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYEaTMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYEaTMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbYEaTMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 15:12:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31639 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYEaTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 15:12:04 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5307"; a="3376515"
Message-ID: <4841A311.2050008@qualcomm.com>
Date: Sat, 31 May 2008 12:12:17 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched domains
 (ie remove cpu_isolated_map)
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>	<1212085023-22284-3-git-send-email-maxk@qualcomm.com>	<20080529173759.ccbaf8ef.pj@sgi.com>	<483F3559.1030806@qualcomm.com>	<20080529191211.080ec5cf.pj@sgi.com>	<483F8178.7040300@qualcomm.com> <20080530015200.f299afed.pj@sgi.com>
In-Reply-To: <20080530015200.f299afed.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max replied:
>>> I did not see your reply.  Did you send it to me or lkml?
>> http://marc.info/?l=linux-kernel&m=121207910616332&w=2
> 
> Ah - ok - I got that reply, and then lost track of it.  My bad.
> 
> Max wrote, in that earlier reply:
>> Since we do not plan on supporting it I'd say lets get rid of it.
> 
> This doesn't make sense to me.  We don't just decree that we aren't
> planning on supporting something that's already out there and being
> used, and then remove it, on the grounds we aren't supporting it.
> 
> Faceless beauracracies can get away with that ... we can do better.

Ok. Let me ask you this. Would you be ok with a patch that exposes (via sysctl
for example) scheduler balancer mask when cpusets are disabled ?
In other words it will look something like this:
- Rename cpu_isolated_map to sched_balancer_map
- If cpusets are enabled
  o balancer map is compiled out or a noop
  o isolcpus= boot param is compiled out

- If cpusets are disabled
  o balancer map can be changed via /proc/sys/kernel/sched_balancer_mask
    writing to it rebuilds scheduler domains
    cpus not in the mask will be put into NULL domain
  o isolcpus= boot param is available for compatibility

Why do this ?
Two reasons. It would not longer be a hack, it simply exposes scheduler
feature that is not otherwise available without cpusets. And there is no
conflict with sched domain management when cpusets are enabled. ie cpuset have
exclusive control on domains).

Max

