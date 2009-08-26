Return-Path: <linux-kernel-owner+w=401wt.eu-S1751433AbZHZOyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbZHZOyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZHZOyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:54:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35857 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZHZOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ktiya2nzjPeB93aW8dLmTotcbQm6WzssYp9hcJE9ZEEEeF4S8YhErbD8OFtvqFwidG
         EvnoT7ELREWJbnkzyA59fzq9H5+eHw3OzsaiOqTny41IKLKhEN0OG2cVrO/kDU5fUtQC
         UI7Vm/hv5rUgTbtWl7tMIyTrwXHAd9/d7t4yE=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1251297910.1791.22.camel@maxim-laptop>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
	 <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>
	 <1251264700.7538.1178.camel@twins> <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 17:54:03 +0300
Message-Id: <1251298443.4791.7.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-08-26 at 17:45 +0300, Maxim Levitsky wrote:
> On Wed, 2009-08-26 at 09:47 -0400, Christoph Lameter wrote:
> > On Wed, 26 Aug 2009, raz ben yehuda wrote:
> > 
> > > How will the kernel is going to handle 32 processors machines ?  These
> > > numbers are no longer a science-fiction.
> > 
> > The kernel is already running on 4096 processor machines. Dont worry about
> > that.
> > 
> > > What i am suggesting is merely a different approach of how to handle
> > > multiple core systems. instead of thinking in processes, threads and so
> > > on i am thinking in services. Why not take  a processor and define this
> > > processor to do just firewalling ? encryption ? routing ? transmission ?
> > > video processing... and so on...
> > 
> > I think that is a valuable avenue to explore. What we do so far is
> > treating each processor equally. Dedicating a processor has benefits in
> > terms of cache hotness and limits OS noise.
> > 
> > Most of the large processor configurations already partition the system
> > using cpusets in order to limit the disturbance by OS processing. A set of
> > cpus is used for OS activities and system daemons are put into that set.
> > But what can be done is limited because the OS threads as well as
> > interrupt and timer processing etc cannot currently be moved. The ideas
> > that you are proposing are particularly usedful for applications that
> > require low latencies and cannot tolerate OS noise easily (Infiniband MPI
> > base jobs f.e.)
> 
> My 0.2 cents:
> 
> I have always been fascinated by the idea of controlling another cpu
> from the main CPU.
> 
> Usually these cpus are custom, run proprietary software, and have no
> datasheet on their I/O interfaces.
> 
> But, being able to turn an ordinary CPU into something like that seems
> to be very nice.
> 
> For example, It might help with profiling. Think about a program that
> can run uninterrupted how much it wants.
> 
> I might even be better, if the dedicated CPU would use a predefined
> reserved memory range (I wish there was a way to actually lock it to
> that range)
> 
> On the other hand, I could see this as a jump platform for more
> proprietary code, something like that: we use linux in out server
> platform, but out "insert buzzword here" network stack pro+ can handle
> 100% more load that linux does, and it runs on a dedicated core....
> 
> In the other words, we might see 'firmwares' that take an entire cpu for
> their usage.
This is exactly what offsched (sos) is. you got it. SOS was partly inspired by the notion of a GPU. 
Processors are to become more and more redundant and Linux as an
evolutionary system must use it. why not offload raid5 write engine ?
why not encrypt in a different processor ?
Also , having so many processors in a single OS means a bug prone
system , with endless contention points when two or more OS processors
interacts. let's make things simpler.
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

