Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYLSRCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYLSRCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYLSRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:01:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYLSRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:01:53 -0500
Date: Fri, 19 Dec 2008 12:01:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] cpumask: convert kernel trace functions
In-Reply-To: <494BD1D0.5080201@sgi.com>
Message-ID: <alpine.DEB.1.10.0812191201200.26432@gandalf.stny.rr.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <20081219160145.272814000@polaris-admin.engr.sgi.com> <alpine.DEB.1.10.0812191114070.28744@gandalf.stny.rr.com> <494BD1D0.5080201@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Dec 2008, Mike Travis wrote:
> > 
> > 
> > How does this save memory if we just allocate a cpumask var everytime
> > we allocate a ring buffer?  Is cpumask_var_t a mask of possible CPUS and 
> > not NR_CPUS?
> > 
> > Otherwise, I see this as just adding one extra pointer.
> > 
> > -- Steve
> 
> Hi Steve,
> 
> Yes, eventually, the cpumask_var_t will be allocated based on cpumask_size()
> which will become BITS_TO_LONG(nr_cpu_ids) instead of BITS_TO_LONGS(NR_CPUS)
> as soon as the kernel becomes "cpumask" clean.  (clean being that it ignores
> all bits >= nr_cpu_ids.)
> 
> Note that on small NR_CPUS count systems, cpumask_var_t is a static array
> and no allocation happens, so it only kicks in when CONFIG_CPUMASK_OFFSTACK=y.

OK, that explains a lot. Thanks for the explanation.

-- Steve

