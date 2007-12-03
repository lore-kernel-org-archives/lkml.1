Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbXLCLe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbXLCLe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXLCLew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:34:52 -0500
Received: from www.tglx.de ([62.245.132.106]:59618 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbXLCLev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:34:51 -0500
Date: Mon, 3 Dec 2007 12:34:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jakub Jelinek <jakub@redhat.com>
cc: Thomas Gleixner <tglx@www.tglx.de>, Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fedora's latest gcc produces unbootable kernels
In-Reply-To: <20071203085817.GQ16835@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.0.9999.0712031231370.6765@localhost.localdomain>
References: <20071201154223.1b052d39@poseidon.drzeus.cx> <20071201184752.33536d09@poseidon.drzeus.cx> <20071201212054.2377c8be@poseidon.drzeus.cx> <23803.203.197.163.97.1196669842.squirrel@www.tglx.de> <20071203085817.GQ16835@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Jakub Jelinek wrote:

> On Mon, Dec 03, 2007 at 09:17:22AM +0100, Thomas Gleixner wrote:
> > I looked at the disassembly but I can not spot the problem.
> > 
> > I think the real problem is somewhere else. Likely candidates are
> > hrtimer_forward() or hrtimer_start() - in that order.
> 
> Should be hopefully fixed in latest Fedora gcc.  The problem was in code like
> typedef union { long long int s; } U;
> typedef struct { U u; } S;
> 
> void foo (S *s, long long int x, unsigned long int y)
> {
>   s->u = ({ (U) { .s = s->u.s + x * y }; });
> }
> 
> where a backport of a recent optimization of mine, without which gcc handles
> terribly initializers from compound literals (which is something hrtimer
> uses just everywhere - why can't ktime.h for #if BITS_PER_LONG == 64 || defined(CONFIG_KTIME_SCALAR)
> just use a scalar rather than union with a scalar in it??),

Of course just to annoy you :)

Seriously, we want the same code/initializers for both the scalar and the
sec/nsec case. That's where the union comes from.

Thanks,

	tglx
