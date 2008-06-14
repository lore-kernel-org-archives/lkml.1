Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYFNVrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYFNVrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYFNVrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:47:35 -0400
Received: from malt.us-lot.org ([78.31.108.14]:2478 "EHLO malt.us-lot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbYFNVre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:47:34 -0400
X-Greylist: delayed 2237 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2008 17:47:34 EDT
Date: Sat, 14 Jun 2008 22:10:11 +0100
From: Adam Sampson <ats@offog.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de
Subject: 2.6.25.4-rt6 doesn't build with RT_GROUP_SCHED && !SMP
Message-ID: <20080614211007.GA2229@cartman.at.offog.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Homepage: http://offog.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The RT-patched kernel 2.6.25.4-rt6 doesn't build if you've turned on
group scheduling but not SMP, owing to this bit of code in
kernel/sched_rt.c:

#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
        if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
                struct rq *rq = rq_of_rt_rq(rt_rq);
                rt_rq->highest_prio = rt_se_prio(rt_se);

                if (rq->online)
                        cpupri_set(&rq->rd->cpupri, rq->cpu,
                                   rt_se_prio(rt_se));
        }
#endif

struct rq only has "cpu" and "online" elements if CONFIG_SMP is enabled.

My full config is here: http://offog.org/stuff/config-2.6.25

Thanks,

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>
