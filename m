Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYK0Sb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYK0Sb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYK0SbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:31:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39116 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYK0SbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:31:21 -0500
Date: Thu, 27 Nov 2008 19:41:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mingo@elte.hu, x86@kernel.org, andi@firstfloor.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 02/24] perfmon: base code
Message-ID: <20081127184149.GR6703@one.firstfloor.org>
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com> <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain> <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com> <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, where is it checked ? Where is checked whether Oprofile runs or not ?

That is done using the perfctr reservation. I saw that somewhere in the
patchkit. The NMI watchdog uses that too.

> > The Oprofile reservation you see is built on top of the cpumask reservation.
> > It tries to allocate in one call and atomically ALL the CPUs as this is the way
> > Oprofile operates. Thus it fails if one perfmon system-wide session or one
> > perfmon per-thread exists.
> 
> This only prevents oprofile from starting, but it does neither prevent
> thread sessions nor does it prevent a perfmon per cpu session on a cpu
> which was onlined after oprofile started, simply because it's bit is
> missing in the CPU mask. 

The perfctr reservation is global over all CPUs.

-Andi 

-- 
ak@linux.intel.com
