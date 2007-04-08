Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXDHTO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXDHTO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDHTO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:14:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47427 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXDHTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:14:26 -0400
Message-ID: <46193EDF.3000303@zytor.com>
Date: Sun, 08 Apr 2007 12:13:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184735.GC29180@thunk.org>
In-Reply-To: <20070408184735.GC29180@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 
> You could, but then you're succeptible to a memory allocation attack.
> If you have an arbitrarily large directory (say, one with multiple
> millions of entries), and the attacker program calls seekdir() after
> every single readdir() call, you would then force the kernel to
> allocate and then pin arbitrarily large amounts of memory, which as
> you point out, as currently specified by the POSIX specification, you
> are not allowed to release until closedir().
> 
> This could be done in userspace, by forcing glibc to readdir() the
> entire directory into memory, at which point seekdir()/telldir() will
> work just fine.  But for a really big directory, this could consume a
> huge amount of space. 
> 
> If we had the 64-byte telldir cookie that I had proposed, then in
> userspace we could simply associate that 64-byte telldir cookie with a
> small 32-bit integer, either in memory, or in some berkdb or tdb
> interface, at least until the use of telldir/seekdir had actually
> disappeared.  (Which probably wouldn't take that long; I really doubt
> there are that many users of it out there, so it's probably OK if they
> suffer a performance penality if they use this really wretched and
> horrible interface.)
> 

If you want to have a large cookies, you could have glibc allocate a 
memory block to store it, and have glibc responsible for keeping track 
of it.  As far as I know, off_t can hold a pointer on all our 
implementations (only 32-bit machines have 32-bit off_t as an option; 
Alpha *might* be an exception but I don't think so.)

> I'll also note, by the way, that there are those who have been much
> more cavalier with breaking the wireless interface or the udev/sys
> interface after one year.  Not that I would agree with that, but over
> some deprecation period measured in years, I think it is possible to
> nuke what was a horribly misguided interface that should have never
> existed.  Whoever invented it really should receive the brown paper
> award for one of the worst design decisions of all time.

Readdir/telldir are much, much, more fundamental than that.  We're 
talking interfaces which have been standardized for longer than Linux 
itself has existed.

	-hpa
