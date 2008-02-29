Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYB2Ihn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYB2Ihn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYB2Ihf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:37:35 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbYB2Ihe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:37:34 -0500
Date: Fri, 29 Feb 2008 00:36:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       Max Krasnyanskiy <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080229003628.0989794e.akpm@linux-foundation.org>
In-Reply-To: <20080229003155.bbab795d.akpm@linux-foundation.org>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080229003155.bbab795d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 00:31:55 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> So I shall drop git-sched again.

And when I do this I get:

***************
*** 8125,8137 ****
  	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
  }
  
- static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
  		u64 rt_period_us)
  {
  	return sched_group_set_rt_period(cgroup_tg(cgrp), rt_period_us);
  }
  
- static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
  {
  	return sched_group_rt_period(cgroup_tg(cgrp));
  }
--- 8125,8137 ----
  	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
  }
  
+ static int cpu_rt_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
  		u64 rt_period_us)
  {
  	return sched_group_set_rt_period(cgroup_tg(cgrp), rt_period_us);
  }
  
+ static u64 cpu_rt_period_read_u64(struct cgroup *cgrp, struct cftype *cft)
  {
  	return sched_group_rt_period(cgroup_tg(cgrp));
  }
***************
*** 8367,8374 ****
  	},
  	{
  		.name = "rt_period_us",
- 		.read_uint = cpu_rt_period_read_uint,
- 		.write_uint = cpu_rt_period_write_uint,
  	},
  #endif
  };
--- 8367,8374 ----
  	},
  	{
  		.name = "rt_period_us",
+ 		.read_u64 = cpu_rt_period_read_u64,
+ 		.write_u64 = cpu_rt_period_write_u64,
  	},
  #endif
  };

and if I then fix that up, and later restore git-sched, Paul's patch is now
broken.

Your trees continue to cause more trouble than anyone else's have ever
done, by a lot.

Let me try yesterday's git-sched.patch.
