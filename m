Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYFFPCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYFFPCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbYFFPCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:02:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbYFFPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:02:37 -0400
Date: Fri, 6 Jun 2008 08:01:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <20080606115305.GA20345@wotan.suse.de>
Message-ID: <alpine.LFD.1.10.0806060756090.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com>
 <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org> <20080606012749.GA12187@wotan.suse.de> <alpine.LFD.1.10.0806052018440.3473@woody.linux-foundation.org>
 <20080606115305.GA20345@wotan.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Jun 2008, Nick Piggin wrote:
> 
> Well... a single lock is only going to be so scalable. I don't see how
> it could be done really significantly better?

My worry is that I did something wrong in the slowpath, and that there is 
some thundering-herd-wakeup kind of thing that makes that much slower than 
it should be.

The slow path doesn't much matter from the angle of counting individual 
cycles, but it still matters very much from a bigger picture. Does it have 
bad behavior where we wake up a thousand readers, but then a writer gets 
to come in first and all the readers have to go to sleep again?

That's one thing I tried to avoid in the second version (the "Another 
approch" commit) where a read-wakeup actually moves the readers from the 
pending count to the final count - both to get more fairness (which can be 
_bad_ for performance), but also because I think it can avoid pathological 
cases (reader starvation and unnecessary futex wakeup).

		Linus
