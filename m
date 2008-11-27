Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYK0MWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYK0MWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYK0MW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:22:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60658 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYK0MW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:22:28 -0500
Date: Thu, 27 Nov 2008 13:32:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127123257.GI6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain> <20081126140054.GX6703@one.firstfloor.org> <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain> <20081127100602.GF6703@one.firstfloor.org> <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 12:35:54PM +0100, stephane eranian wrote:
> On Thu, Nov 27, 2008 at 12:31 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> The only reason why I have to deal with NMI is not so much to allow
> >> for profiling irq-off regions but because I have to share the PMU with
> >> the NMI watchdog. Otherwise I'd have to fail  or disable the NMI watchdog
> >> on the fly.
> >
> > The NMI watchdog is now off by default so failing with it enabled
> > is fine.
> 
> Yes, but most likely it is on in distro kernels.

Really? Why?

Old distros of course do it but only because they run old 
kernels.

> You have to handle the case where the NMI fires while you are holding
> a perfmon lock. What you have in the patch (and the the fully-featured version)
> is that we get the NMI and we stop the PMU WITHOUT grabbing any perfmon
> lock, and the we repost the interrupt with the regular vector. We also make sure
> we grab the RIP at NMI. That is the one we want to see reported in the sampling
> buffer.
> 
> I am still wondering how Oprofile handles the case where multiple processes or
> threads access the same file descriptor.

It uses per CPU buffers (so no races on the writer) and readers can
of course use a lock to coordinate between themselves.

I wrote a similar scheme for mce_log() (although the current version
in tree has some issues too)

-Andi
