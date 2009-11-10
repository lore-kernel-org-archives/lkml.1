Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZKJVV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZKJVV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbZKJVV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:21:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:37618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbZKJVVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:21:54 -0500
Subject: Re: [tip:perf/core] perf tools, Alpha: Add Alpha support to perf.h
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
       tglx@linutronix.de, rth@twiddle.net, mingo@elte.hu, mcree@orcon.net.nz,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <84144f020910260508n47ef067ci4adfd02cd3f87edd@mail.gmail.com>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
	 <tip-fcd14b3203b538dca04a2b065c774c0b57863eec@git.kernel.org>
	 <84144f020910260508n47ef067ci4adfd02cd3f87edd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 22:21:36 +0100
Message-ID: <1257888096.4108.482.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 14:08 +0200, Pekka Enberg wrote:
> > +#ifdef __alpha__
> > +#include "../../arch/alpha/include/asm/unistd.h"
> > +#define rmb()          asm volatile("mb" ::: "memory")
> > +#define cpu_relax()    asm volatile("" ::: "memory")
> > +#endif
> 
> OK, I'll bite. We tell userspace developers not to include kernel
> headers. Why is it okay for perf to do it (especially for something
> that's in asm)? 

The reason we take the explicit arch header is because we need the perf
syscall thingy, which isn't yet in the installed system unistd.h because
that's probably some ancient version.

Once distro's have had perf enabled kernels for long enough that all of
userspace has the syscall bits we can remove it.

