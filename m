Return-Path: <linux-kernel-owner+w=401wt.eu-S1763803AbZAGXUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763803AbZAGXUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZAGXUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:20:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763606AbZAGXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:19:59 -0500
Date: Wed, 7 Jan 2009 15:19:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231368870.6686.16.camel@norville.austin.ibm.com>
Message-ID: <alpine.LFD.2.00.0901071518570.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <4963584A.4090805@novell.com>  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>
  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>  <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>  <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>
  <1231329783.11687.287.camel@twins>  <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> 
 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231368870.6686.16.camel@norville.austin.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Dave Kleikamp wrote:
> 
> Do you need to even do that if CONFIG_DEBUG_PAGEALLOC is unset?

No.

> Something like:
> 
> #ifdef CONFIG_DEBUG_PAGEALLOC
>                 /*
>                  * Need to access the cpu field knowing that
>                  * DEBUG_PAGEALLOC could have unmapped it if
>                  * the mutex owner just released it and exited.
>                  */
>                 if (probe_kernel_address(&thread->cpu, cpu))
>                         break;
> #else
> 		cpu = thread->cpu;
> #endif

yes. That would work fine.

			Linus
