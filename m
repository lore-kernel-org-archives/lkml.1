Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbZFKXZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbZFKXZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZFKXZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:25:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35114 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbZFKXZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:25:23 -0400
Date: Thu, 11 Jun 2009 19:25:17 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, mark.langsdorf@amd.com
Subject: Re: [PATCH 3/6] cpumask: avoid playing with cpus_allowed in
	powernow-k8.c
Message-ID: <20090611232517.GA32486@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	mark.langsdorf@amd.com
References: <20090611225928.E6FF4DDDA1@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611225928.E6FF4DDDA1@ozlabs.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:59:58PM +0930, Rusty Russell wrote:
 > From: Rusty Russell <rusty@rustcorp.com.au>
 > 
 > It's generally a very bad idea to mug some process's cpumask: it could
 > legitimately and reasonably be changed by root, which could break us
 > (if done before our code) or them (if we restore the wrong value).
 > 
 > I did not replace powernowk8_target; it needs fixing, but it grabs a
 > mutex (so no smp_call_function_single here) but Mark points out it can
 > be called multiple times per second, so work_on_cpu is too heavy.

This one clashes with some diffs I merged earlier in cpufreq.git.
Can you rebase on top of that please?
(The other two were fine).

Otherwise, they all look ok to me. As long as they survive testing I
see no reason not to push them for .31.

Thanks,

	Dave

