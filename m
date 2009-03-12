Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZCLVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZCLVqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZCLVqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:46:15 -0400
Received: from www.tglx.de ([62.245.132.106]:50182 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbZCLVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:46:14 -0400
Date: Thu, 12 Mar 2009 22:43:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: use current->time_slack_ns for rt
 tasks too
In-Reply-To: <49B97FA8.1060504@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0903122240030.29264@localhost.localdomain>
References: <20090312075559.9856.28822.stgit@Aeon>  <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>  <49B913DC.6040807@linux.intel.com> <1236866529.22914.3694.camel@twins>  <alpine.LFD.2.00.0903121524370.29264@localhost.localdomain>
 <1236869314.22914.3697.camel@twins> <49B923C4.20901@linux.intel.com> <49B97FA8.1060504@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Darren Hart wrote:
> Arjan van de Ven wrote:
> > Peter Zijlstra wrote:
> > > Looking at the default_timer_slack_ns stuff, do we want something like
> > > the below?
> > 
> > the original idea was that you had a default slack that you got from exec
> > time,
> > and then something you could just tweak around yourself independently....
> > 
> > this would throw that out of the window.
> 
> It seems to me that changing your scheduling class from userspace would be
> reasonable justification to change the timer slack to a default value for that
> class.  Thoughts?

We have already five locations in the kernel where we do policy
decisions on the slack value for rt-tasks. Such things need to be
decided at fork time and modified by scheduler class changes or the
prctl interface and not at random places where we need to hand the
slack value to the hrtimer code.

We just want to use task->timer_slack_ns and be done.

Thanks,

	tglx
