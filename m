Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbYA1O73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbYA1O73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbYA1O7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:59:16 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33894 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758099AbYA1O7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:59:15 -0500
Date: Mon, 28 Jan 2008 08:59:10 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: [CPUISOL] CPU isolation extensions
Message-Id: <20080128085910.7d38e9f5.pj@sgi.com>
In-Reply-To: <1201511305.6149.30.camel@lappy>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
	<1201511305.6149.30.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the CC, Peter.

  Ingo - see question at end of message.

Max wrote:
> We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
> I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.

I recently added the per-cpuset flag 'sched_load_balance' for some
other realtime folks, so that they can disable the kernel scheduler
load balancing on isolated CPUs.  It essentially allows for dynamic
control of which CPUs are isolated by the scheduler, using the cpuset
hierarchy, rather than enhancing the 'isolated_cpus' mask.   That
'isolated_cpus' mask remained a minimal kernel boottime parameter.
I believe this went to Linus's tree about Oct 2007.

It looks like you have three additional tweaks for realtime in this
patch set, with your patches:

  [PATCH] [CPUISOL] Do not route IRQs to the CPUs isolated at boot
  [PATCH] [CPUISOL] Support for workqueue isolation
  [PATCH] [CPUISOL] Isolated CPUs should be ignored by the "stop machine"

It would be interesting to see a patchset with the above three realtime
tweaks, layered on this new cpuset 'sched_load_balance' apparatus, rather
than layered on changes to make 'isolated_cpus' more dynamic.  Some of us
run realtime and cpuset-intensive loads on the same system, so like to
have those two capabilities co-operate with each other.

Ingo - what's your sense of the value of the above three realtime tweaks
       (the last three patches in Max's patch set)?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
