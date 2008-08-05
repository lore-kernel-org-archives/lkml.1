Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYHED4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYHED4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYHED4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:56:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43299 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752227AbYHED4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:56:42 -0400
Date: Mon, 4 Aug 2008 22:56:36 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080804225636.541527e8.pj@sgi.com>
In-Reply-To: <48977E81.4040207@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080802063900.6615e5ca.pj@sgi.com>
	<48948C3A.6050805@qualcomm.com>
	<20080802225127.2b0d138b.pj@sgi.com>
	<4895F3ED.4020805@qualcomm.com>
	<20080804010033.0d1b0549.pj@sgi.com>
	<48977E81.4040207@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Actually it is appropriate, and there is one more user of the
> arch_reinit_sched_domains() which is S390 topology updates.
> Those things (mc_power and topology updates) have to update domain flags based
> on the mc/smt power and current topology settings.

Hmmm ... ok I suppose.

Could we have the kernel/sched.c code, in this case, call the
kernel/cpuset.c routine async_rebuild_sched_domains(), rather
than the synchronous rebuild_sched_domains() call (in your naming)
which required details of the get_online_cpus() and put_online_cpus()
wrapping to leak into kernel/sched.c:arch_reinit_sched_domains()
routine?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
