Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZK1RaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZK1RaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 12:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZK1RaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 12:30:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZK1RaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 12:30:22 -0500
Date: Sat, 28 Nov 2009 09:30:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <20091123145409.GA29627@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0911280927180.2561@localhost>
References: <20091123145409.GA29627@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Nov 2009, Nick Piggin wrote:
> 
> Last time this issue came up that I could see, I don't think
> there were objections to making rwlocks fair, the main
> difficulty seemed to be that we allow reentrant read locks
> (so a write lock waiting must not block arbitrary read lockers).

We have at least one major rwlock user - tasklist_lock or whatever. And 
that one definitely depends on being able to do 'rwlock()' in an 
interrupt, without other rwlock'ers having to disable irq's (even if there 
might be a new writer coming in on another cpu).

That usage case _might_ be turned into RCU or something similar, in which 
case I don't think any major rwlock users remain. However, if that's the 
case, then why should anybody care about fairness any more either?

So as far as I can tell, we have only one real user of rwlocks where 
livelocks might be relevant, but that one real user absolutely _requires_ 
the unfair behavior.

		Linus
