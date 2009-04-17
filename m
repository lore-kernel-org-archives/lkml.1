Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbZDQSPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbZDQSPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761782AbZDQSPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:15:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756389AbZDQSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:15:31 -0400
Date: Fri, 17 Apr 2009 11:03:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jonathan Corbet <corbet@lwn.net>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount syscalls
 with a mutex
In-Reply-To: <20090417113142.3151579b@bike.lwn.net>
Message-ID: <alpine.LFD.2.00.0904171039080.4042@localhost.localdomain>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu>
 <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu> <1239987885.23397.4817.camel@laptop> <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain> <20090417113142.3151579b@bike.lwn.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Jonathan Corbet wrote:

> On Fri, 17 Apr 2009 10:21:06 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > And I know we had patches for file locking BKL-removal at some point. What 
> > happened to them? Were they just broken, or forgotten, or waiting in Jon's 
> > tree, or what?
> 
> Not in my tree, I've not seen them.  I could maybe take a look at that,
> I've just about recovered from my fasync experience...:)

Hmm. It might also just be my fevered imagination. I'd like to say it was 
Matthew Wilcox, but really, my mind is going.

Ahh. Bug google backs me up. As long as I have google, I can keep 
Alzheimer's at bay: "Negative scalability by removal of lock_kernel()" 
thread on lkml back in October 2000. After we had actually done the BKL 
removal.

So we actually did apply it (in 2.4.0-test9, and then reverted it again 
(in -test11, I think). Google for "file_lock_sem fs/locks.c" and see some 
of the discussion. The end result was to go back to the BKL due to Apache 
slowdowns.

But I seem to remember a later patch (in the last year or two) from Willy 
too. Google doesn't help me, so that's probably just my fevered mind. But 
I'm cc'ing Willy anyway.

		Linus
