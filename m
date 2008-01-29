Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbYA2Qv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbYA2Qv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbYA2QvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:51:10 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50427 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760441AbYA2QvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:51:08 -0500
Date: Tue, 29 Jan 2008 10:51:04 -0600
From: Paul Jackson <pj@sgi.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, dmitry.adamushko@gmail.com,
       rostedt@goodmis.org, menage@google.com, rientjes@google.com,
       tong.n.li@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com, sgrubb@redhat.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       nickpiggin@yahoo.com.au
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129105104.d70f36ef.pj@sgi.com>
In-Reply-To: <479F0507.BA47.005A.0@novell.com>
References: <1201600428.28547.87.camel@lappy>
	<1201604243.28547.101.camel@lappy>
	<20080129053005.bc7a11d7.pj@sgi.com>
	<1201607401.28547.124.camel@lappy>
	<479F0507.BA47.005A.0@novell.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory wrote:
> This is correct.  We have the balance policy polymorphically associated
> with each sched_class, and the CFS load-balancer and RT "load" (really,
> priority) balancer can coexist together at the same time and across
> arbitrary #s of cores

So ... we have the option of having all sched_classes coexist polymorphically.

That I didn't realize until this thread.

Now ... do we -want- to ?)

That is, what is the easiest kernel-user API to work with and understand?

Is it one where we essentially expose sched_class to user space, and let
them pick their sched_class, or pick none of the above (don't balance)?

Or is it one where, other than the special case my batch schedulers need
to not balance at all, we expose nothing more to user space, and provide
all sched_class load balancers to all sched_domains (other than those
not balanced at all)?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
