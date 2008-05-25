Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYEYNk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYEYNk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYEYNkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:40:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYEYNkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:40:14 -0400
Date: Sun, 25 May 2008 09:40:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <20080525141921.79c1bdc2@core>
Message-ID: <Pine.LNX.4.58.0805250937430.22587@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
 <Pine.LNX.4.58.0805250915410.20625@gandalf.stny.rr.com> <20080525141921.79c1bdc2@core>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 May 2008, Alan Cox wrote:

> > And what happens when we have 10GHz boxes that can do migration in 1us,
> > and the delay that is asked for is 2us. We can return early.  I don't like
> > to place assumptions of this kind that can hurt with future hardware
> > enhancements.
>
> Then in the hypothetical future you fix it, and for now its clearly

No, I'm saying that we don't need to account for the migrate. It will
only make the delay longer, and if the code was preemptible, that delay
is not guaranteed to be that long anyway.


> documented. Th preempt botch in the current tree breaks all sorts of
> existing real world setups so needs to go. (and we have people who do
> stuff like mdelay(150);

My updated patch takes Thomas's patch into consideration. There's no need
to put on limited timeouts due to migration.

-- Steve

