Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbXERENA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbXERENA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 00:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXEREMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 00:12:54 -0400
Received: from holomorphy.com ([66.93.40.71]:38301 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbXEREMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 00:12:53 -0400
Date: Thu, 17 May 2007 21:13:09 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070518041309.GA19966@holomorphy.com>
References: <20070513153853.GA19846@elte.hu> <20070518001841.GA21140@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518001841.GA21140@gnuppy.monkey.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 05:38:53PM +0200, Ingo Molnar wrote:
>> So i've added a yield workaround to -v12, which makes it work similar to 
>> how the vanilla scheduler and SD does it. (Xorg has been notified and 
>> this bug should be fixed there too. This took some time to debug because 
>> the 3D driver i'm using for testing does not use sys_sched_yield().) The 
>> workaround is activated by default so -v12 should work 'out of the box'.

On Thu, May 17, 2007 at 05:18:41PM -0700, Bill Huey wrote:
> This is an incorrect analysis. OpenGL has the ability to "yield" after
> every frame specifically for SGI IRIX (React/Pro) frame scheduler (driven
> by the system vertical retrace interrupt) so that it can free up CPU
> resources for other tasks to run. The problem here is that the yield
> behavior is treated generally instead of specifically to a particular
> proportion scheduler policy.
> The correct solution is for the app to use a directed yield and a policy
> that can directly support it so that OpenGL can guaratee a frame rate
> governed by CPU bandwidth allocated by the scheduler.
> Will is working on such a mechanism now.

What? AFAIK the CFS patches already implement directed yields.


-- wli
