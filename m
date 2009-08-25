Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZHYUfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZHYUfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZHYUfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:35:47 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:33630 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZHYUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:35:46 -0400
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, raz ben yehuda <raziebe@gmail.com>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <4A943A00.9080609@nortel.com>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
	 <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 13:35:44 -0700
Message-Id: <1251232544.8208.18.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 13:22 -0600, Chris Friesen wrote:
> On 08/25/2009 01:08 PM, Peter Zijlstra wrote:
> 
> > Christoph, stop being silly, this offline scheduler thing won't happen,
> > full stop.
> > 
> > Its not a maintainable solution, it doesn't integrate with existing
> > kernel infrastructure, and its plain ugly.
> > 
> > If you want something work within Linux, don't build kernels in kernels
> > or other such ugly hacks.
> 
> Is it the whole concept of isolating one or more cpus from all normal
> kernel tasks that you don't like, or just this particular implementation?
> 
> I ask because I know of at least one project that would have used this
> capability had it been available.  As it stands they have to live with
> the usual kernel threads running on the cpu that they're trying to
> dedicate to their app.
> 

Its already possible to *almost* vacate a CPU except for a handful of
kernel threads.

There are various hacks being distributed which also offload / suppress
timer and rcu activity from specific CPUs.

Everything I have looked at has been hackish and racy, and no one using
this is pusing any of it upstream.

OFFLINING solves the problem in a minimalist way, and only for tasks
with very limited interaction with the Kernel.

In contrast however, almost all tasks with such limited Kernel
interaction should be able to do fine under PREEMPT_RT after some cpuset
work.

For those which absolutely cannot handle a handful of kernel threads
sharing the CPU, the only option today is one or another form of
hackery, and amongst those options, this would seem attractive by its
mere simplicity.

But complete CPU isolation for user-space tasks still eludes.

Sven


> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

