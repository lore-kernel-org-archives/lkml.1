Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbXE3Cmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbXE3Cmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXE3CmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:42:24 -0400
Received: from ozlabs.org ([203.10.76.45]:43488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXE3CmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:42:23 -0400
Subject: Re: CPU hotplug: system hang on CPU hot remove during `pfmon
	--system-wide'
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       Dipankar <dipankar@in.ibm.com>
In-Reply-To: <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
References: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com>
	 <20070528065550.GL6157@in.ibm.com>
	 <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 May 2007 12:42:01 +1000
Message-Id: <1180492921.30202.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 13:56 -0700, Linus Torvalds wrote:
> 
> On Mon, 28 May 2007, Srivatsa Vaddagiri wrote:
> >
> > 	So is it settled now on what approach we are going to follow (freezer 
> > vs lock based) for cpu hotplug? I thought that Linus was not favouring freezer 
> > based approach sometime back ..
> 
> As far as I'm concerned, we should
>  - use "preempt_disable()" to protect against CPU's coming and going 
>  - use "stop_machine()" or similar that already honors preemption, and 
>    which I trust a whole lot  more than freezer.
>  - .. especially since this is already how we are supposed to be protected 
>    against CPU's going away, and we've already started doing that (for an 
>    example of this, see things like e18f3ffb9c from Andrew)

Indeed, this is how it was supposed to work.

	Note that it is possible to make stop_machine() an even larger hammer,
by scheduler mods to flush all the preempted tasks.  This would drop the
requirement for preempt_disable().

But cute as that would be, I've been waiting until someone demonstrates
an actual need...

Rusty.


