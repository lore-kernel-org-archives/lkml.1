Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbZAHQM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbZAHQM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbZAHQMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:12:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758569AbZAHQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:12:34 -0500
Date: Thu, 8 Jan 2009 08:11:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231426014.11687.456.camel@twins>
Message-ID: <alpine.LFD.2.00.0901080746290.3283@localhost.localdomain>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins>  <20090108141808.GC11629@elte.hu>
 <1231426014.11687.456.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Jan 2009, Peter Zijlstra wrote:
> 
> This was done because the interaction between trylock_slowpath and that
> -1000 state hurt my head.

Yeah, it was a stupid hacky thing to avoid the "list_empty()", but doing 
it explicitly is fine (we don't hold the lock, so the list isn't 
necessarily stable, but doing "list_empty()" is fine because we don't ever 
dereference the pointers, we just compare the pointers themselves).

I shouldn't have done that hacky thing, it wasn't worth it.

		Linus
