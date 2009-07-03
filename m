Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbZGCVbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbZGCVbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbZGCVb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:31:29 -0400
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:39264 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756365AbZGCVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:31:28 -0400
Date: Fri, 3 Jul 2009 17:43:12 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
In-Reply-To: <20090703075822.GA13505@elte.hu>
Message-ID: <Pine.LNX.4.64.0907031729040.17432@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
 <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
 <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu>
 <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
 <20090629210206.GB13125@elte.hu> <Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy>
 <20090703075822.GA13505@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Jul 2009, Ingo Molnar wrote:
> That would give a mixture of hardware and software counter based IRQ
> instrumentation features that looks quite compelling. Any comments
> on what features/capabilities you'd like to see in this area?

I'm mainly interested in just an aggregate total of "this many interrupts 
occurred".  It wouldn't even need to be separated out by type or number. 
I don't know if the metric would be useful to anyone else.  I tried to 
hack this up a long time ago, to have the result reported with rusage()
but never got anywhere with it.

> Btw., perfcounters still has no support for older Intel CPUs such as
> P3's and P2's - and they have pretty sane PMUs - so if you have such
> a machine (which your perfmon contribution suggests you might
> have/had) and are interested it would be nice to get support for
> them. P4 support is interesting too but more challenging.

I was indeed the one who got perfmon2 running on Pentium Pro, Pentium II, 
and MIPS R12k.  For all those though there was an existing PMU driver and 
I just added the appropriate "case" statements to enable support, and then 
provided an updated list of available counters to the userspace utility. 
The only real kernel hacking involved was the week spent tracking down a 
hard-to-debug interrupt issue on the MIPS machine.

Unfortunately I think writing PMU drivers is a bit beyond me, for the 
amount of time I have.  Especially as the relevant machines I have are 
located in relatively inaccessible locations (and PMU mistakes can lock up 
the machines) plus it can take the better part of a day to compile 2.6 
kernels on some of those machines.

Vince
