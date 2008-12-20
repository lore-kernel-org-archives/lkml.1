Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYLTKfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYLTKfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 05:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYLTKfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 05:35:30 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57805 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYLTKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 05:35:30 -0500
Date: Sat, 20 Dec 2008 16:06:02 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-ID: <20081220103602.GC24181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175622.29812.69201.stgit@drishya.in.ibm.com> <20081219135508.9c6217ba.akpm@linux-foundation.org> <20081220043638.GA24181@dirshya.in.ibm.com> <20081219204455.5f954823.akpm@linux-foundation.org> <20081220100228.GB24181@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081220100228.GB24181@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-20 15:32:28]:

> * Andrew Morton <akpm@linux-foundation.org> [2008-12-19 20:44:55]:
> 
> > On Sat, 20 Dec 2008 10:06:38 +0530 Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > > > 
> > > > kernel/sched.c: In function 'schedule':
> > > > kernel/sched.c:3679: warning: 'active_balance' may be used uninitialized in this function
> > > > 
> > > > This warning is correct - the code is buggy.
> > > 
> > > Yes this is my code bug.  I did not see the warning in sched.c.  Is
> > > there any build option that I need to pass in order to get -Wall
> > > effect?
> > 
> > That was just with plain old kbuild: `make allmodconfig;make'.
> > 
> > That warning was produced by gcc-4.0.2.  If you're using something more
> > recent then gcc has regressed.
> 
> This is an interesting problem.  I am unable to get that warning in the
> following GCC versions even with a combination of the following
> cmdline options: -Wall -Wextra -Wuninitialized
> 
> gcc version 4.1.2 20070502
> gcc version 4.2.3
> 
> I will look for older gcc and check this out.

I am able to get the above warning in 
gcc version 3.4.6 (Debian 3.4.6-9)
with default kbuild, no additional params.

Did not get the warning in 
gcc version 4.1.3 20080623

Hence there has been some change in GCC that prevented the
uninitialized warning.

--Vaidy
