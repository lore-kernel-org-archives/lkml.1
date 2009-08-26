Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbZHZQVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbZHZQVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZHZQVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:21:31 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:36017 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763AbZHZQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:21:31 -0400
Date: Wed, 26 Aug 2009 12:20:45 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <1251302598.18584.31.camel@twins>
Message-ID: <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
References: <1250983671.5688.21.camel@raz>  <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>  <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>  <1251021133.14003.172.camel@marge.simson.net> 
 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>  <1251222993.7023.53.camel@marge.simson.net>  <alpine.DEB.1.10.0908251402300.17963@gentwo.org>  <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>  <1251264700.7538.1178.camel@twins>
 <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop>  <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
 <1251302598.18584.31.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Peter Zijlstra wrote:

> On Wed, 2009-08-26 at 11:41 -0400, Christoph Lameter wrote:
> > On Wed, 26 Aug 2009, Peter Zijlstra wrote:
> >
> > > Why waste a whole cpu for something that could be done by part of one?
> >
> > Because of latency and performance requirements
>
> Latency is the only one, and yes people have been using hacks like this,
> I've also earlier mentioned RTAI, RTLinux and L4-Linux which basically
> do the same thing.
>
> The problem is, that its not linux, you cannot run something on a these
> off-cores and use the same functionality as linux, if you could it'd not
> be offline.

Right. We discussed this. Why are you repeating the same old arguments?

> Carving out cpus just doesn't work in the long run (see below for more),
> it adds configuration burdens on people and it would duplicate
> functionality (below), or it provides it in a (near) useless manner.

Its pretty simple. Just isolate the cpu, forbid the OS to run anything on
it. Allow a user space process to change its affinity to the isolated cpu.
Should the process be so stupid as to ask the OS for services then just
switch it back to a regular processor. Interaction is still possible via
shared memory communication as well as memory mapped devices.

> If you hack up special cases like this, then only your one use-case gets
> better and the rest doesn't, or it might actually get worse, because it
> got less attention.

What special case? This is a generic mechanism.

> > The kernel interactions can be done while running on another (not
> > isolated) cpu.
>
> There needs to be some communication between the isolated and non
> isolated part, otherwise what's the point. Even when you'd let it handle
> say a network device as pure firewall, you'd need to configure the
> thing, requiring interaction.

Shared memory, memory mapped devices?

> Interaction of any sorts gets serialization requirements, and from there
> on things tend to grow.

Yes and there are mechanism that provide the serialization without OS
services.

> > The functionality does not exist. This is about new features.
>
> It is not, he is proposing to use these cores for:
>
>  - network stuff, we already have that
>  - raid5 stuff, we already have that
>  - other stuff we already have

Right. I also want to use it for network stuff. Infiniband which support
memory mapped registers and stuff. Its generic not special as you state.

> Then there is the issue of what happens when a single core isn't
> sufficient for the given task, then you'd need to split up, again
> creating more interaction.

Well yes you need to create synchronization methods that do not require OS
interaction.

> > > If you think the kernel is too fat and does superfluous things for your
> > > needs, help trim it.
> >
> > Mind boogling nonsense. Please stop fantasizing and trolling.
>
> Oh, to lay down the crack-pipe and sod off.

Dont have one here. Whats a sod off?
