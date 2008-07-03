Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYGCHG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYGCHG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYGCG5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbYGCCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:35:19 -0400
Date: Wed, 2 Jul 2008 19:35:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
In-Reply-To: <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org>
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org> <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
 <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com> <486B8B6C.2050109@firstfloor.org> <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jul 2008, Vitaly Mayatskikh wrote:
> 
> Linus wanted this routine to be extremely dumb.

Well, I wanted it simple and dumb, but not dumber than _necessary_.

I think

	if (cleartail)
		memset(dst,0,len);
	return len;

is basically what we should have at the end. Simple and sweet.

Now, the stuff that comes *before* that point is the "try to fix up one 
byte at a time" thing, which I'd like to be simple and dumb. At least to 
start with.

Of course, I also suspect that *eventually* we might want to make it 
smarter and more complex. For example, while performance isn't a primary 
issue, we might want to eventually avoid having to do _two_ faults (once 
in the fast unrolled or word-at-a-time loop, and once in the byte-for-byte 
one), by limiting the byte-for-byte one to be within a page, but that 
would be a "future enhancement" thing.

		Linus
