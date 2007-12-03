Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXLCJzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXLCJzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbXLCJzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:55:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56019 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXLCJzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:55:02 -0500
Date: Mon, 3 Dec 2007 10:55:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203095501.GB28560@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202165913.3eaebee6@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 04:59:13PM -0800, Arjan van de Ven wrote:
> On Mon, 3 Dec 2007 01:07:41 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > We really need to get better diagnostics for the
> > > bad-kernel-behavior-that-is-seen-as-bug cases. If we ever want to
> > > get to the scenario where we have a more or less robust measure of
> > > kernel quality (and we're not all that far off for several cases),
> > > one thing
> > 
> > One measure to kernel quality is to recover well from IO errors
> > (like network problems or broken block devices)
> 
> yes. and this patch will flag cases that don't (yet) work well

If the device/server/... takes more than 2 minutes to recover, how does this
imply the error path "does not work well" ? Or is your goal to handle all 
possible errors in less than two minutes? [That might be a worthy goal,
but is probably far from easy and likely impossible in some cases]

> > This patch will likely work against that by breaking error paths.
> 
> it won't break error paths, it will at most put a warning in the log.
> It doesn't kill or otherwise damage the system or process.

>From the user perspective a kernel randomly throwing backtraces is 
a broken kernel. 

> 
> > 
> > > This patch is a step in the right direction there, by quite a
> > > lot.
> > > 
> > > I really don't understand what your objection is to this patch...
> > > is it that an enterprise distro can't ship with it on? (Which is
> > > fine btw)
> > 
> > Any distribution aimed at end users cannot ship with it on. 
> 
> That's a pretty bold statement; assuming that the TASK_KILLABLE patch
> is in, I don't see the problem.

iirc TASK_KILLABLE fixed NFS only. While that's a good thing there are
unfortunately a lot more subsystems that would need the same treatment.

> > Also in general I have my doubts that the false positive:real bug
> > ratio of this warning is well balanced.
> 
> I'll just have to disagree with you then; but both of us are making
> wild guesses. Only one way to get the real false positive percentage.

Yes let's break things first instead of looking at the implications closely.

-Andi

