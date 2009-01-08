Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZAHCd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZAHCd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbZAHCdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:33:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219AbZAHCdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:33:35 -0500
Date: Wed, 7 Jan 2009 21:33:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <alpine.LFD.2.00.0901071552550.3057@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901072130110.29075@gandalf.stny.rr.com>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231368870.6686.16.camel@norville.austin.ibm.com> <alpine.LFD.2.00.0901071518570.3057@localhost.localdomain> <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
 <alpine.LFD.2.00.0901071552550.3057@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Jan 2009, Linus Torvalds wrote:
> > Should that be:
> > 
> > #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_MEMORY_HOTPLUG)
> 
> Well, probably CONFIG_MEMORY_HOTREMOVE, no? And I'd actually suggest that 
> unplugging should have a stop-machine if it doesn't already, just because 
> it's such a special case - like module removal.

I do not think stop-machine will help, unless that spinning is protected 
by preempt-disable. If the task gets preempted after grabbing the owner 
thread_info, and then stop-machine runs, the memory disappears, the task 
is scheduled back, accesses the owner thread_info and then page-fault.

-- Steve

