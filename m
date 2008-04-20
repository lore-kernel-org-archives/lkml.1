Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYDTWxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYDTWxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYDTWxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:53:38 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34659 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752543AbYDTWxh (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:53:37 -0400
Date: Mon, 21 Apr 2008 08:53:11 +1000
From: David Chinner <dgc@sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420225311.GI108924158@sgi.com>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080419110034.34b70bd5@laptopd505.fenrus.org> <480AAC20.4050604@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480AAC20.4050604@sandeen.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 09:36:16PM -0500, Eric Sandeen wrote:
> Arjan van de Ven wrote:
> 
> > On the flipside the arguments tend to be
> > 1) certain stackings of components still runs the risk of overflowing
> > 2) I want to run ndiswrapper
> > 3) general, unspecified uneasyness.
> > 
> > For 1), we need to know which they are, and then solve them, because even on x86-64 with 8k stacks
> > they can be a problem (just because the stack frames are bigger, although not quite double, there).
> 
> Except, apparently, not, at least in my experience.
> 
> Ask the xfs guys if they see stack overflows on x86_64, or on x86.

We see them regularly enough on x86 to know that the first question
to any strange crash is "are you using 4k stacks?". In comparison,
I have never heard of a single stack overflow on x86_64....

> I've personally never seen common stack problems with xfs on x86_64, but
> it's very common on x86.  I don't have a great answer for why, but
> that's my anecdotal evidence.

Why? Because XFS makes extensive use of 64 bit types and so stack
usage in the critical paths changes by a relatively small amount
between 32 bit and 64 bit machines.  IIRC, x86_64 only uses about
30% more stack than x86. So given that the stack doubles on x86_64
and we only increase usage (in XFS) from about 1500 bytes to 2000
bytes of stack usage, we have *lots* more stack space to spare on
x86_64 compared to 4k stacks on x86....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
