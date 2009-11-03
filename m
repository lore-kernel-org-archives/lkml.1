Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZKCPuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZKCPuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZKCPub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:50:31 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41257 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZKCPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:50:31 -0500
Date: Tue, 3 Nov 2009 07:50:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>, Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [RELEASE] Userspace RCU 0.3.0
Message-ID: <20091103155028.GC6726@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091103150234.GA20060@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103150234.GA20060@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 10:02:34AM -0500, Mathieu Desnoyers wrote:
> Hi everyone,
> 
> I released userspace RCU 0.3.0, which includes a small API change for
> the "deferred work" interface. After discussion with Paul, I decided to
> drop the support for call_rcu() and only provide defer_rcu(), to make
> sure I don't provide an API with the same name as the kernel RCU but
> with different arguments and semantic. It will generate the following
> linker error if used:
> 
> file.c:240: undefined reference to 
>    `__error_call_rcu_not_implemented_please_use_defer_rcu'
> 
> Note that defer_rcu() should *not* be used in RCU read-side C.S.,
> because it calls synchronize_rcu() if the queue is full. This is a major
> distinction from call_rcu(). (note to self: eventually we should add
> some self-check code to detect defer_rcu() nested within RCU read-side
> C.S.).
> 
> I plan to eventually implement a proper call_rcu() within the userspace
> RCU library. It's not, however, a short-term need for me at the moment.

I can tell that we need to get you going on some real-time work.  ;-)

(Sorry, but I really couldn't resist!)

							Thanx, Paul
