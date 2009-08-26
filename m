Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbZHZQEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbZHZQEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZHZQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:04:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZHZQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:04:45 -0400
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
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
	 <1251297910.1791.22.camel@maxim-laptop>  <1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 18:03:18 +0200
Message-Id: <1251302598.18584.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 11:41 -0400, Christoph Lameter wrote:
> On Wed, 26 Aug 2009, Peter Zijlstra wrote:
> 
> > Why waste a whole cpu for something that could be done by part of one?
> 
> Because of latency and performance requirements

Latency is the only one, and yes people have been using hacks like this,
I've also earlier mentioned RTAI, RTLinux and L4-Linux which basically
do the same thing.

The problem is, that its not linux, you cannot run something on a these
off-cores and use the same functionality as linux, if you could it'd not
be offline.

The past year or so you've been whining about the tick latency, and I've
seen exactly _0_ patches from you slimming down the work done in there,
even though I pointed out some obvious things that could be done.

Carving out cpus just doesn't work in the long run (see below for more),
it adds configuration burdens on people and it would duplicate
functionality (below), or it provides it in a (near) useless manner.

If you were to work on lowering the linux latency in the full kernel
sense, you'd help out a lot of people, many use-cases would improve and
you'd be helpful to he greater good.

If you hack up special cases like this, then only your one use-case gets
better and the rest doesn't, or it might actually get worse, because it
got less attention.

> > You're bound to have interaction between the core os and these
> > partitions you want, non of it different from how threads in the kernel
> > would interact, other than that you're going to re-invent everything
> > already present in the kernel.
> 
> The kernel interactions can be done while running on another (not
> isolated) cpu.

There needs to be some communication between the isolated and non
isolated part, otherwise what's the point. Even when you'd let it handle
say a network device as pure firewall, you'd need to configure the
thing, requiring interaction.

Interaction of any sorts gets serialization requirements, and from there
on things tend to grow.

> > You don't, you make things more complex by introducing duplicate
> > functionality.
> 
> The functionality does not exist. This is about new features.

It is not, he is proposing to use these cores for:

 - network stuff, we already have that
 - raid5 stuff, we already have that
 - other stuff we already have

Then there is the issue of what happens when a single core isn't
sufficient for the given task, then you'd need to split up, again
creating more interaction.

> > If you think the kernel is too fat and does superfluous things for your
> > needs, help trim it.
> 
> Mind boogling nonsense. Please stop fantasizing and trolling.

Oh, to lay down the crack-pipe and sod off.
