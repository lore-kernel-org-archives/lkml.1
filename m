Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbXKTXAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbXKTXAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXKTXAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:00:45 -0500
Received: from THUNK.ORG ([69.25.196.29]:34008 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbXKTXAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:00:44 -0500
Date: Tue, 20 Nov 2007 18:00:12 -0500
From: Theodore Tso <tytso@mit.edu>
To: Helge Deller <deller@gmx.de>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-ID: <20071120230012.GF26022@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Helge Deller <deller@gmx.de>, Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <200711182038.22055.deller@gmx.de> <200711182240.35015.deller@gmx.de> <20071120063120.GD17536@waste.org> <200711202259.58745.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711202259.58745.deller@gmx.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 10:59:58PM +0100, Helge Deller wrote:
> > Even with a futex? Or userspace atomics? 
> 
> Yes, you'll need a futex or similiar.
>
> The problem is then more, where will you put that futex to be able
> to protect against other processes ?
> 
> Best solution is probably shared memory, but then the question will
> be, who is allowed to access this memory/futex ?
>
> Will any process (shared library) be allowed to read/write/delete it?
>
> At this stage you then suddenly run from a locking-problem into a
> security problem, which is probably equally hard to solve.

Basically, the only way to solve this problem 100% in userspace would
be with a userspace daemon running as a privileged user, and some kind
of Unix domain socket.

Patches to implement this in the e2fsprogs UUID library would be
greatfully accepted.

> Sounds simple and is probably fast enough.
>
> But do you really want to add then another daemon to the Linux
> system, just in case "some" application needs somewhen a UUID ?
> 
> And I think such an implementation is more complex, would need more
> memory, file handles, and so on than this simple kernel patch.

Well, it probably is less code, but keep in mind to really get things
right, you need to store the UUID counter on disk, so there is some
complexity which is needed in userspace anyway.

One bigger question which is why do you want to use time-based UUID's?
With the kernels random number generator, the random UUID's should be
quite good enough for your purposes.

> I think mkfs was a very bad example from my side. I should not have
> mentioned this one.  Nevertheless, time-based UUIDs are used in
> quite many other and more critical applications than e2fsprogs
> tools.

Actually, these days e2fsprogs uses random-based UUID's.

							- Ted
