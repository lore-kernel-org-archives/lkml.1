Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYK0ShX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYK0ShX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYK0ShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:37:10 -0500
Received: from www.tglx.de ([62.245.132.106]:38733 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYK0ShJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:37:09 -0500
Date: Thu, 27 Nov 2008 19:36:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: eranian@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mingo@elte.hu, x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 02/24] perfmon: base code
In-Reply-To: <20081127184149.GR6703@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0811271933500.3325@localhost.localdomain>
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com> <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain> <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com> <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
 <20081127184149.GR6703@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Andi Kleen wrote:

> > Well, where is it checked ? Where is checked whether Oprofile runs or not ?
> 
> That is done using the perfctr reservation. I saw that somewhere in the
> patchkit. The NMI watchdog uses that too.
> 
> > > The Oprofile reservation you see is built on top of the cpumask reservation.
> > > It tries to allocate in one call and atomically ALL the CPUs as this is the way
> > > Oprofile operates. Thus it fails if one perfmon system-wide session or one
> > > perfmon per-thread exists.
> > 
> > This only prevents oprofile from starting, but it does neither prevent
> > thread sessions nor does it prevent a perfmon per cpu session on a cpu
> > which was onlined after oprofile started, simply because it's bit is
> > missing in the CPU mask. 
> 
> The perfctr reservation is global over all CPUs.

So this mean we manage resources on multiple levels, some bits here
and some bits there and five checks in each code path do get them all.

Really convincing concept.

Thanks,

	tglx
