Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbYDPQoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbYDPQoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYDPQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:44:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47839 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbYDPQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:44:07 -0400
Date: Wed, 16 Apr 2008 10:44:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Oliver Neukum <oliver@neukum.org>
Cc: Ingo Oeser <ioe-lkml@rameria.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080416164404.GM9191@parisc-linux.org>
References: <4803AD91.5020001@firstfloor.org> <200804161831.10510.oliver@neukum.org> <20080416163413.GL9191@parisc-linux.org> <200804161842.52739.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804161842.52739.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 06:42:50PM +0200, Oliver Neukum wrote:
> Am Mittwoch, 16. April 2008 18:34:14 schrieb Matthew Wilcox:
> > On Wed, Apr 16, 2008 at 06:31:08PM +0200, Oliver Neukum wrote:
> > > Am Mittwoch, 16. April 2008 18:16:52 schrieb Matthew Wilcox:
> > > > The basic idea is that you get back a cookie from the kcounter_claim()
> > > > which you have to hand to the kcounter_release() function so it
> > > > knows which one you released. ?It's similar to mutex debugging except
> > > 
> > > So in addition to the kcounter we need to save a token in a data structure?
> > > In fact, there must be a data structure that can house that token. So you
> > > can no longer live with a pointer just to a device descriptor, but every
> > > individual use of a resource must have an associated data structure?
> > 
> > That's right.  Do you have an example where this would be inconvenient?
> > I couldn't find one.  For example, with USB, you could place one in the
> > struct urb.
> 
> That's a data structure we really want to shrink. And furthermore, the needs
> of the use cases should shape the locking primitives, not the reverse.

The cookies aren't checked by the kcounter implementation if
CONFIG_DEBUG_KCOUNTER isn't set.  So you can avoid storing them if it's
*really* that important to shrink your data structures.

You'll still have to check the return value from the various
kcounter_claim* APIs for errors, of course.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
