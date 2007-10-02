Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbXJCKuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbXJCKuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXJCKuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:50:14 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:30496 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753852AbXJCKuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:50:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Qd5FQp89wU8irmvKRxbAu1h+ctOtwm086sS1ES3immHPUE3DF7VbOlr7lZ0dNXoa4NH63Wyat5yX439+vslvCTIBHJ+91Ce5Zdl28TnxDqCe5WeSeQUmSclk3IfLvU+ldeAQCpu+jGlB5VsvPrPdKy+sH9oIQdWYk3b0AgQyevM=  ;
X-YMail-OSG: 7wAfoocVM1nJm5b7zN07eyG_P4KptBZfvFvlSe2h2Hg2Wh1GJyXGkY87pPex0l3vAx9Pr1m86g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Wed, 3 Oct 2007 03:56:17 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710030209.56879.nickpiggin@yahoo.com.au> <20071003025518.7c184905.pj@sgi.com>
In-Reply-To: <20071003025518.7c184905.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030356.18090.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 19:55, Paul Jackson wrote:
> > > Yeah -- cpusets are hierarchical.  And some of the use cases for
> > > which cpusets are designed are hierarchical.
> >
> > But partitioning isn't.
>
> Yup.  We've got a square peg and a round hole.  An impedance mismatch.
> That's the root cause of this entire wibbling session, in my view.

Basically, yeah.


> > > To repeat myself, in some cases, such as batch schedulers running in a
> > > subset of the CPUs on a large system, the code that knows some of the
> > > needs for load balancing does not have system wide control to mandate
> > > hard partitioning.  The batch scheduler can state where it is depending
> > > on load balancing being present, and the system administrator can
> > > choose or not to turn off load balancing in the top cpuset, thereby
> > > granting or not control over load balancing on the CPUs controlled by
> > > the batch scheduler to the batch scheduler.
> >
> > Why isn't that possible with my approach?
>
> If I understand your approach to the kernel-to-user interface correctly
> (sometimes I doubt I do) then your approach expected some user space code
> or person or semi-intelligent equivalent to define a flat partition,
> which will then be used to determine the sched domains.
>
> In the batch scheduler case, running on a large shared system used
> perhaps by several departments, no one entity can do that.  One person,
> perhaps the system admin, knows if they want to give complete control
> of some big chunk of CPUs to a batch scheduler.  The batch scheduler,
> written by someone else far away and long ago, knows which jobs are
> actively running on which subsets of the CPUs the batch scheduler is
> using.
>
> There is no single monolithic entity on such systems who knows all and
> can dictate all details of a single, flat, system-wide partitioning.

OK, so I don't exactly understand you either. To make it simple, can
you give a concrete example of a cpuset hierarchy that wouldn't
work?


> The partitioning has to be sythesized from the combined requests of
> several user space entities.  That's ok -- this is bread and butter
> work for cpusets.

OK, so to really do anything different (from a non-partitioned setup),
you would need to set sched_load_balance=0 for the root cpuset?
Suppose you do that to hard partition the machine, what happens to
newly created tasks like kernel threads or things that aren't in a
cpuset?
