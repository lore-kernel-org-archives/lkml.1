Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZANEHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZANEHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZANEGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:06:53 -0500
Received: from THUNK.ORG ([69.25.196.29]:35167 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZANEGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:06:52 -0500
Date: Tue, 13 Jan 2009 23:06:45 -0500
From: Theodore Tso <tytso@mit.edu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090114040645.GG14730@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	David Rientjes <rientjes@google.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <20090113224941.GA14730@mit.edu> <20090113230240.GA30192@ioremap.net> <20090114011137.GC14730@mit.edu> <20090114012001.GA3402@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114012001.GA3402@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:20:01AM +0300, Evgeniy Polyakov wrote:
> 
> It is not about the possibility to change the sources, but the way
> interface is exported to the userspace. Right now it is not usable for
> some cases. And forcing applications, which are actually cross-platform,
> depending on the way linux controls its own oom-killer is noticebly more
> hackish than selecting a system-wide process by its name.

And we can change that interface if it's not the right one, or perhaps
extend it.  After all, you are are proposing extending that interface;
just in a really horrible, hackish way.

> You believe that changing apache to control oom_adj is the right way to
> deal with linux oom-killer? Do we already flight to the moon?

Actually, I would believe the right answer is adding a new resource
limit which can be set using the standard getrlimit()/setrlimit()
interface, and then have apache use this standard interface as a way
of configuring itself --- much like how a process can change other
resource limits, such as the number of file descriptors it has open,
etc.  And if what you want to do is simply make the process volunteer
to be one of the first processes shot by the OOM killer, the apache
process wouldn't even need setuid privileges to lower the "OOM
protection" resource limit.

I think this is cleaner than echoing a magic value to
/proc/self/oom_adj, and it won't be the first time various open source
programs have been changed to take advantage of Linux-specific
interfaces, especially if there's no other standard way of doing
things --- and an extension of BSD's getrlimit()/setrlimit() is
natural and makes a lot of sense.  Heck, apache has been changed to
take advantage of Linux's epoll interface....

						- Ted
