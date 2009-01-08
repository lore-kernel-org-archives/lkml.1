Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZAHSB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZAHSB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZAHSBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:01:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873AbZAHSBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:01:43 -0500
Date: Thu, 8 Jan 2009 10:00:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231434515.14304.27.camel@think.oraclecorp.com>
Message-ID: <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Unrelated:

On Thu, 8 Jan 2009, Chris Mason wrote:
>
> RIP: 0010:[<ffffffff8024f4de>]  [<ffffffff8024f4de>] __cmpxchg+0x36/0x3f

Ouch. HOW THE HELL DID THAT NOT GET INLINED?

cmpxchg() is a _single_ instruction if it's inlined, but it's a horrible 
mess of dynamic conditionals on the (constant - per call-site) size 
argument if it isn't.

It looks like you probably enabled the "let gcc mess up inlining" config 
option.

Ingo - I think we need to remove that crap again. Because gcc gets the 
inlining horribly horribly wrong. As usual.

				Linus
