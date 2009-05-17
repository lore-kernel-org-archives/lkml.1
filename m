Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZEQWz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZEQWz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZEQWzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:55:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783AbZEQWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:55:10 -0400
Date: Sun, 17 May 2009 15:54:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh@veritas.com>
cc: Andi Kleen <ak@linux.intel.com>, Ian Campbell <ian.campbell@citrix.com>,
       Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
In-Reply-To: <Pine.LNX.4.64.0905172335170.23616@blonde.anvils>
Message-ID: <alpine.LFD.2.01.0905171552020.3301@localhost.localdomain>
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com> <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain> <4A0DC797.7040502@linux.intel.com> <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain> <Pine.LNX.4.64.0905171536470.23834@blonde.anvils>
 <alpine.LFD.2.01.0905171502160.3301@localhost.localdomain> <Pine.LNX.4.64.0905172335170.23616@blonde.anvils>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 May 2009, Hugh Dickins wrote:
> 
> No, not sure at all, that was just a conclusion I jumped to.
> Though I think I was seeing it on x86-32 too.

Ok, the 32-bit calling convention doesn't do any of that, even though we 
compile the kernel with -mregparm=3. Any function with varargs arguments 
gets all arguments passed on the stack, and we just pass the frame pointer 
along, so there's no extra buffers.

So if you saw it on x86-32, then I think the only empty hole is indeed 
due to that 'char function[KSYM_SYMBOL_LEN]' (and whatever stack alignment 
code gcc does). And yes, it should be much better now.

			Linus
