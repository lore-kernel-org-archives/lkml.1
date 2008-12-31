Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYLaJlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYLaJlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYLaJky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:40:54 -0500
Received: from phunq.net ([64.81.85.152]:44792 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752296AbYLaJkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:40:53 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Wed, 31 Dec 2008 01:40:49 -0800
User-Agent: KMail/1.9.5
Cc: tux3@tux3.org, sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
References: <200812301935.49303.phillips@phunq.net> <200812310000.55256.phillips@phunq.net> <20081231083123.GF10725@disturbed>
In-Reply-To: <20081231083123.GF10725@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812310140.49503.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 00:31, Dave Chinner wrote:
> On Wed, Dec 31, 2008 at 12:00:54AM -0800, Daniel Phillips wrote:
> > On Tuesday 30 December 2008 23:34, sniper wrote:
> > > Great, I have mounted tux3 filesystem under UML with stuffs in this mail,
> > > but I still can't debug it with gdb. Anyone gives me suggestion?
> ....
> > In the mean time, you could just tell gdb to mask off all segfaults,
> > but would be kind of problematic for debugging.
> 
> Not really. That's the default setting I use for XFS debugging. I
> just put breakpoints on "panic" and "stop" (sometimes
> bust_spinlocks) and just let the kernel panic routine handle the
> segv which will trip a breakpoint. Then just walk back up the stack
> to the function that triggered the real SEGV and go from there.
> 
> This is pretty much necessary for XFS debugging because
> just mounting a filesystem causes 8-10 SEGV signals to occur.
> You simply can't run xfsqa when that is occurring...

Thanks for the howto.  That was Jeff's suggestion also, but it would
be so much slicker if it was automagic, and first-time users would not
be constantly hitting this.  I realize the difficulty.  We have two
big tools that are not a perfect match, and don't know how to
cooperate to smooth out the bumps.  Sigh.  It was ever thus.

UML used to know about gdb, because it had to - the ptrace version of
UML could not be debugged as a regular task so gdb was execced from
UML.  The result was very slick.  You said "linux debug" and you would
land at the gdb command prompt from which you could continue, or
"linux debug=go" and it would continue without pausing, great for
rapid development.  Now, it's all much more high tech and better I am
sure, but not as slick.  You have to set up a .gdbinit, it's more to
do and not something you are going to get around to doing on every
machine you might develop on.  So I typically end up just typing cont
and lots of carriage returns, not so pretty.

By the way, gdb -args linux ubda=... is very convenient.

Added Jeff to CC.  Thanks Jeff, I still think UML is the best kernel
development tool ever.

Regards,

Daniel
