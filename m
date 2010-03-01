Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab0CASRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:17:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0CASRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:17:21 -0500
Subject: Re: [PATCH][RESEND] Export per-tid and per-tgid cputime in 
 nanoseconds.
From: Peter Zijlstra <peterz@infradead.org>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, kenchen@google.com
In-Reply-To: <af41c7c41003010744m54fc325bjccae0ff6965656eb@mail.gmail.com>
References: <20100227020242.1384.9945.stgit@austin.mtv.corp.google.com>
	 <1267271025.22519.740.camel@laptop>
	 <af41c7c41003010744m54fc325bjccae0ff6965656eb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 19:05:40 +0100
Message-ID: <1267466740.1579.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 07:44 -0800, Divyesh Shah wrote:
> On Sat, Feb 27, 2010 at 3:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, 2010-02-26 at 18:03 -0800, Divyesh Shah wrote:
> > > This can be used by applications to get finer granularity cputime usage on
> > > platforms that use timestamp counters or HPET.
> >
> > I guess the patch looks good, I'm just not sure what HPET got to do with
> > anything.. the scheduler certainly doesn't use HPET for timekeeping, its
> > terribly slow to read.
> 
> Yes you're right. Please ignore the HPET comment.
> 
> >
> > Also, it would be good to get some more justification than 'some
> > applications can use this', which is basically a truism for any patch
> > that adds a user interface.
> 
> 1) This should be useful for a shared or virtualized environment where
> the shared management infrastructure needs to charge each application
> as accurately as possible for cpu usage.
> 2) An application that services different users and does some
> cpu-intensive work may want to measure cpu time spent for each user by
> the serving thread.
> 
> I think applications like web servers, remote database servers, etc.
> fit into the second category.
> 
> For units of work smaller than a jiffy, this really helps as some
> threads could potentially hide from the jiffy based accounting.
> 
> Please let me know if you want me to send the patch again with the
> corrected description and added justification.


Its all should and may, anything concrete?

Also, doesn't muck like schedstat, task_delay_accounting, cpuacct-cgroup
or some other stuff expose this number already?

