Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZH1Uhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZH1Uhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZH1Uha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:37:30 -0400
Received: from www.tglx.de ([62.245.132.106]:42392 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZH1Uha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:37:30 -0400
Date: Fri, 28 Aug 2009 22:34:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux-foundation.org>
cc: Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <alpine.DEB.1.10.0908281619520.15573@gentwo.org>
Message-ID: <alpine.LFD.2.00.0908282231260.19335@localhost.localdomain>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org>
 <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain> <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com> <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
 <alpine.DEB.1.10.0908281446520.7317@gentwo.org> <alpine.LFD.2.00.0908282100040.19335@localhost.localdomain> <alpine.DEB.1.10.0908281551450.17784@gentwo.org> <alpine.LFD.2.00.0908282158100.19335@localhost.localdomain>
 <alpine.DEB.1.10.0908281619520.15573@gentwo.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Christoph Lameter wrote:

> On Fri, 28 Aug 2009, Thomas Gleixner wrote:
> 
> > The statistics stuff needs to be tackled anyway as we need to offload
> > the sched accounting to some other cpu.
> 
> The vm statisticcs in mm/vmstat.c are different from the sched accounting.

I know, but the problem is basically the same. Delegate the stats to
someone else.
 
> > What slab queue stuff is running on timers and cannot be switched off
> > in such a context?
> 
> slab does run a timer every 2 second to age queues. If there was activity
> then there can be a relatively long time in which we periodically throw
> out portions of the cached data.

Right, but why does that affect a CPU which is marked "I'm not
involved in that game" ?
 
> > Device specific stuff should not happen on such a CPU when there is no
> > device handled on it.
> 
> The device may periodically check for conditions that require action.

Errm. The device is associated to some other CPU, so why would it
require action on an isolated one ? Or are you talking about a device
which is associated to that isolated CPU ?

Thanks,

	tglx

