Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZKWPxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZKWPxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZKWPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:53:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:36786 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753053AbZKWPxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:53:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18+V1NSPDo+A5lnQfOcxaFT2/ETnYJGduFU2GsTVl
	ziqWwo/tkP8Uz6
Subject: Re: newidle balancing in NUMA domain?
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091123152931.GD19175@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de>
	 <1258987059.6193.73.camel@marge.simson.net>
	 <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop>
	 <20091123152931.GD19175@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 16:53:37 +0100
Message-Id: <1258991617.6182.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:

> So basically about the least well performing or scalable possible
> software architecture. This is exactly the wrong thing to optimise
> for, guys.

Hm.  Isn't fork/exec our daily bread?

> The fact that you have to coax the scheduler into touching heaps
> more remote cachelines and vastly increasing the amount of inter
> node task migration should have been kind of a hint.
> 
> 
> > Fork balancing only works until all cpus are active. But once a core
> > goes idle it's left idle until we hit a general load-balance cycle.
> > Newidle helps because it picks up these threads from other cpus,
> > completing the current batch sooner, allowing the program to continue
> > with the next.
> > 
> > There's just not much you can do from the fork() side of things once
> > you've got them all running.
> 
> It sounds like allowing fork balancing to be more aggressive could
> definitely help.

It doesn't. Task which is _already_ forked, placed and waiting over
yonder can't do spit for getting this cpu active again without running
so he can phone home.  This isn't only observable with x264, it just
rubs our noses in it.  It is also quite observable in a kbuild.  What if
the waiter is your next fork?

	-Mike

