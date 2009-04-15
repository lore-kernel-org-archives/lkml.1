Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZDOPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZDOPY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZDOPYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:24:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbZDOPYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:24:20 -0400
Date: Wed, 15 Apr 2009 08:19:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: tj@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
In-Reply-To: <2193.1239791070@redhat.com>
Message-ID: <alpine.LFD.2.00.0904150808550.4132@localhost.localdomain>
References: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <2193.1239791070@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Hmm. Why not move it all above the '#include <asm/percpu.h>'?
> 
> There are circular dependencies between the x86 arch headers that both use
> this and are used to implement this, and it's a bit fragile.

Grr. Indeed it seems to be. Nasty. Header files seem to want that 
DECLARE_PER_CPU() thing without all the other baggage that is implied by 
including all of <linux/percpu.h>, so they just include <asm/percpu.h> 
directly instead.

What a mess.

So maybe we could move DEFINE_PER_CPU in there too? It's less than 
perfect, but at least we'd have things together rather than split in 
really odd ways.

		Linus
