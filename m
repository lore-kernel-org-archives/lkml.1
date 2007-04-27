Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbXD0PQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbXD0PQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbXD0PQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:16:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbXD0PQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:16:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
Date: Fri, 27 Apr 2007 17:20:06 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org> <1177684764.3565.20.camel@johannes.berg> <1177685391.3565.22.camel@johannes.berg>
In-Reply-To: <1177685391.3565.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271720.08150.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 16:49, Johannes Berg wrote:
> On Fri, 2007-04-27 at 16:39 +0200, Johannes Berg wrote:
> 
> > Good point. Though if we go for passing the interrupt-enable setting as
> > an argument then many drivers will have the same
> > "if (irqs_disabled()) return" code. Hm. I guess passing it isn't even
> > strictly necessary.
> 
> Eh, the point I actually wanted to make is that many drivers don't care
> for the irqs disabled case and would have to add code to exclude it.

I think we can use 'stages' and pass them as arguments to the functions.

In that case we can have two callbacks for the hibernation (I'd prefer to say
'hibernation' instead of 'suspend to disk' from now on), one 'quiesce' callback
and one 'activate' callback that can be called many times in one
snapshot/restore cycle with different arguments, for example:

quiesce(PREPARE) -- that may be needed for drivers that allocate much memory
before quiescing devices (if any)
...
quiesce(PRE_SNAPSHOT)
...
quiesce(PRE_SNAPSHOT_IRQ_OFF)
...
activate(POST_SNAPSHOT_IRQ_OFF)
...
activate(POST_SNAPSHOT)
...
activate(FINISH)

etc.

Greetings,
Rafael
