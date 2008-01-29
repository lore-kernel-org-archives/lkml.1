Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYA2VJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYA2VJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYA2VIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:08:51 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:35855 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYA2VIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:08:50 -0500
Message-Id: <479F4E1A.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 14:02:34 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Paul Jackson" <pj@sgi.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <rostedt@goodmis.org>, <menage@google.com>, <rientjes@google.com>,
       <tong.n.li@intel.com>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, <sgrubb@redhat.com>,
       <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
       <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <479F01AF.BA47.005A.0@novell.com> <20080129102836.be614579.pj@sgi.com>
 <479F1118.BA47.005A.0@novell.com> <20080129133700.7f1ab444.pj@sgi.com>
 <479F4631.BA47.005A.0@novell.com> <20080129145647.579b7d53.pj@sgi.com>
In-Reply-To: <20080129145647.579b7d53.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at  3:56 PM, in message
<20080129145647.579b7d53.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Gregory wrote:
>> By moving it into the root_domain structure, there is now an instance
>> per (um, for lack of a better, more up to date word) "exclusive"
>> cpuset.   That way, disparate cpusets will not bother each other with
>> overload notifications, etc.
> 
> So the root_domain structure is meant to be the portions of the
> sched_domains that are shared across all CPUs in that sched_domain ?

Thats exactly right.

> 
> And the word 'cpuset', occurring in the above quote twice, should
> be 'sched_domain', right ?  Surely these aren't cpuset's ;).

Yeah, I think I am taking shortcuts in the language ;).  I wanted the root_domain to be an object of shared data that sits at the "root sched_domain", or in other terms the terminating parent in the hierarchy.  And there is one of these suckers created every time a non-overlapping cpuset is created (which was called "exclusive" at the time I wrote it, I believe, but I keep forgetting what you said they are called now ;).  So because the non-overlapping cpuset configuration begat the sched_domain hierarchy, I started using them interchangeably.  Sorry for the confusion :)

> 
> And 'exclusive cpuset' really means 'non-overlapping sched_domain' ?
> 
> Or am I still confused ?

No, I think you nailed it.

> 
> I would like to get our concepts clear, and terms consistent.  That's
> important for those others who would try to understand this.

Very good idea.  Thanks for doing this!

-Greg



