Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYBMIa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYBMIa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbYBMIaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:30:16 -0500
Received: from www.tglx.de ([62.245.132.106]:51698 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbYBMIaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:30:15 -0500
Date: Wed, 13 Feb 2008 09:21:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
In-Reply-To: <20080212230741.576b8004.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802130845380.12988@apollo.tec.linutronix.de>
References: <200802101440.22118.elendil@planet.nl> <20080212230741.576b8004.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Andrew Morton wrote:
> On Sun, 10 Feb 2008 14:40:21 +0100 Frans Pop <elendil@planet.nl> wrote:
> the hrtimer code is preparing an invalid ktime_t.  Note that
> clockevents_program_event() actually fails when this happens - I am
> surprised that this is not causing observeable userspace problems.
> 
> The WARN_ON_ONCE() means that you'll only see this warning once per boot. 
> But the actually error could be happening any number of times without being
> reported.
> 
> Looks pretty serious?

Yes. It's the same problem, which got fixed with:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=62f0f61e6673e67151a7c8c0f9a09c7ea43fe2b5

Frans, Thanks for reporting !

I'm working on a fix.

Thanks,

	tglx
