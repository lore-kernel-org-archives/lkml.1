Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbXIHCRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbXIHCRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 22:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXIHCRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 22:17:02 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40561 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXIHCRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 22:17:00 -0400
Date: Fri, 7 Sep 2007 19:16:56 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: xemul@openvz.org, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, oleg@tv-sign.ru
Subject: Re: [PATCH 5/20] Introduce struct upid
Message-ID: <20070908021656.GA21860@us.ibm.com>
References: <46BC506F.mailGJ711PNHE@openvz.org> <20070814130558.4b5e5e3f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814130558.4b5e5e3f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton [akpm@linux-foundation.org] wrote:
| On Fri, 10 Aug 2007 15:47:59 +0400
| xemul@openvz.org wrote:
| 
| >  struct pid
| >  {
| >  	atomic_t count;
| > @@ -50,6 +50,8 @@ struct pid
| >  	/* lists of tasks that use this pid */
| >  	struct hlist_head tasks[PIDTYPE_MAX];
| >  	struct rcu_head rcu;
| > +	int level;
| > +	struct upid numbers[1];
| 
| You can make this have size [0] now.  It's a gcc extension and
| is used elsewhere in the kernel.

Sorry, we did not respond to this yet :-)

Well, every process has at least one 'struct upid'. The only "cost"
I see with size [1] is having to subtract 1 in create_pid_cachep().

Besides, we create/initialize the 'struct pid' for the idle process
by hand (see INIT_STRUCT_PID in init_task.h).

If we set this size to [0] now, we would need to dynamically allocate
a 'struct upid' during early boot and attach this upid to init_struct_pid.

Or is there a easy way to attach a 'upid' to init_struct_pid, statically ?

Suka

