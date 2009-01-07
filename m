Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbZAGX5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbZAGX5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAGX5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:57:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbZAGX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:57:40 -0500
Date: Wed, 7 Jan 2009 15:57:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
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
In-Reply-To: <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0901071552550.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231368870.6686.16.camel@norville.austin.ibm.com> <alpine.LFD.2.00.0901071518570.3057@localhost.localdomain> <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Steven Rostedt wrote:
> 
> Should that be:
> 
> #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_MEMORY_HOTPLUG)

Well, probably CONFIG_MEMORY_HOTREMOVE, no? And I'd actually suggest that 
unplugging should have a stop-machine if it doesn't already, just because 
it's such a special case - like module removal.

			Linus
