Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYKBPkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYKBPkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 10:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYKBPjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 10:39:52 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4136 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753596AbYKBPjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 10:39:51 -0500
Date: Sun, 2 Nov 2008 10:39:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: (BUG?) round_jiffies() is non-monotonic on SMP
In-Reply-To: <20081101194357.1810f57a@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0811021020020.11781-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, Arjan van de Ven wrote:

> On Sat, 1 Nov 2008 22:36:30 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Sat, 1 Nov 2008, Arjan van de Ven wrote:
> > 
> > > > Come to think of it, is there any good reason why
> > > > round_jiffies() doesn't always round up?  It seems a lot safer.
> > > 
> > > at the time folks had concerns about making a big error in that
> > > direction...
> > 
> > All right then.  Would it be preferable to add a new
> > round_jiffies_up() routine, or to change round_jiffies() so that it
> > never rounds down?
> 
> I'd prefer the former.
> But to be honest.. I would even more prefer the use of range timers ;)
> They're in 2.6.28-rc now ... and more power friendly than rounded timers
> (although I will readily admit that rounding is just easier)

I don't know. One of the cases I know about is the timer embedded in a 
delayed_work -- it's hard to see how that could be converted.

The other could be converted.  But it falls in the category of
"timeouts", as described in Documentation/timers/hrtimers.txt.  As
such, it is best suited to an old-style timer rather than a
high-precision timer (according to hrtimers.txt, at least).  
Furthermore, there doesn't seem to be any documentation describing how
to use the range timer programming interface.

Under the circumstances, I'm not inclined to do any conversions.

Alan Stern

