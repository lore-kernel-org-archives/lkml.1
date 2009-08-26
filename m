Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbZHZPy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbZHZPy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZHZPy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:54:57 -0400
Received: from emulex.emulex.com ([138.239.112.1]:63427 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZHZPy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:54:56 -0400
From: Chetan.Loke@Emulex.Com
To: <raziebe@gmail.com>, <maximlevitsky@gmail.com>
CC: <cl@linux-foundation.org>, <peterz@infradead.org>, <cfriesen@nortel.com>,
       <efault@gmx.de>, <riel@redhat.com>, <mingo@elte.hu>,
       <akpm@linux-foundation.org>, <wiseman@macs.biu.ac.il>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Date: Wed, 26 Aug 2009 08:37:46 -0700
Subject: RE: RFC: THE OFFLINE SCHEDULER
Thread-Topic: RFC: THE OFFLINE SCHEDULER
Thread-Index: AcomXT0TVzWlwrmDRN6SCkD0P3CLvwABK2bg
Message-ID: <412A05BA40734D4887DBC67661F433080FE935AE@EXMAIL.ad.emulex.com>
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
	 <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>
In-Reply-To: <1251298443.4791.7.camel@raz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Aug 2009 15:37:49.0330 (UTC) FILETIME=[2AB05F20:01CA2663]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of raz ben yehuda
> Sent: Wednesday, August 26, 2009 10:54 AM
> To: Maxim Levitsky
> Cc: Christoph Lameter; Peter Zijlstra; Chris Friesen; Mike Galbraith;
> riel@redhat.com; mingo@elte.hu; andrew motron; wiseman@macs.biu.ac.il;
> lkml; linux-rt-users@vger.kernel.org
> Subject: Re: RFC: THE OFFLINE SCHEDULER
> 
> 
> On Wed, 2009-08-26 at 17:45 +0300, Maxim Levitsky wrote:
> > On Wed, 2009-08-26 at 09:47 -0400, Christoph Lameter wrote:
> > > On Wed, 26 Aug 2009, raz ben yehuda wrote:
> > >
> > > > How will the kernel is going to handle 32 processors machines ?
> These
> > > > numbers are no longer a science-fiction.
> > >
> > > The kernel is already running on 4096 processor machines. Dont worry
> about
> > > that.
> > >
> > > > What i am suggesting is merely a different approach of how to handle
> > > > multiple core systems. instead of thinking in processes, threads and
> so
> > > > on i am thinking in services. Why not take  a processor and define
> this
> > > > processor to do just firewalling ? encryption ? routing ?
> transmission ?
> > > > video processing... and so on...
> > >
> > > I think that is a valuable avenue to explore. What we do so far is
> > > treating each processor equally. Dedicating a processor has benefits
> in
> > > terms of cache hotness and limits OS noise.
> > >
> > > Most of the large processor configurations already partition the
> system
> > > using cpusets in order to limit the disturbance by OS processing. A
> set of
> > > cpus is used for OS activities and system daemons are put into that
> set.
> > > But what can be done is limited because the OS threads as well as
> > > interrupt and timer processing etc cannot currently be moved. The
> ideas
> > > that you are proposing are particularly usedful for applications that
> > > require low latencies and cannot tolerate OS noise easily (Infiniband
> MPI
> > > base jobs f.e.)
> >
> > My 0.2 cents:
> >
> > I have always been fascinated by the idea of controlling another cpu
> > from the main CPU.
> >
> > Usually these cpus are custom, run proprietary software, and have no
> > datasheet on their I/O interfaces.
> >
> > But, being able to turn an ordinary CPU into something like that seems
> > to be very nice.
> >
> > For example, It might help with profiling. Think about a program that
> > can run uninterrupted how much it wants.
> >
> > I might even be better, if the dedicated CPU would use a predefined
> > reserved memory range (I wish there was a way to actually lock it to
> > that range)
> >
> > On the other hand, I could see this as a jump platform for more
> > proprietary code, something like that: we use linux in out server
> > platform, but out "insert buzzword here" network stack pro+ can handle
> > 100% more load that linux does, and it runs on a dedicated core....
> >
> > In the other words, we might see 'firmwares' that take an entire cpu for
> > their usage.
> This is exactly what offsched (sos) is. you got it. SOS was partly
> inspired by the notion of a GPU.
> Processors are to become more and more redundant and Linux as an
> evolutionary system must use it. why not offload raid5 write engine ?
> why not encrypt in a different processor ?


RAID/Encryption + GPU. You got it. This is what one of our teams did but by offloading it on a PCIe I/O module and using couple(Protocol+Application core) of cores. One core could run SAS/SATA and other could run your home grown application f/w and/or a linux distro and you could make it do whatever you want. But that was then. Multi-Core systems are now a commodity.


Chetan Loke





