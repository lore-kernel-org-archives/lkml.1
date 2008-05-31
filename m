Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYEaEYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYEaEYD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYEaEXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:23:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbYEaEXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:23:51 -0400
Date: Fri, 30 May 2008 21:23:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com>
 <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Linus Torvalds wrote:
> 
> Also note how you can use 64-bit atomic ops to do that all in user space, 
> without actually requiring 64-bit futex support - as long as the bits that 
> matter for waking (like "was there more than one pending writer") fit in 
> the one 32-bit word.

So here's an example of this:

 - make all the readers/writers actually update a 64-bit word (by using 
   cmpxchg8b in user space to actually get the locks)

 - but organize things so that a reader only needs to look at the high 32 
   bits to actually make it's wakeup-decision, and a sleeping writer only 
   needs to look at the low 32 bits. How? Make the low bits of the words 
   contain the "contention status".

Is it possible? I dunno. I personally suspect it is. I also suspect you 
didn't even try.

			Linus
