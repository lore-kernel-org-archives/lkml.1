Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZAIGnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZAIGnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZAIGnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:43:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60198 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZAIGnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:43:03 -0500
Date: Fri, 9 Jan 2009 07:57:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090109065708.GA26290@one.firstfloor.org>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick> <4966ABF9.9080409@zytor.com> <20090109033531.GR496@one.firstfloor.org> <alpine.LFD.2.00.0901081940260.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901081940260.6528@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 07:42:48PM -0800, Linus Torvalds wrote:
> > I actually often use noinline when developing code simply because it 
> > makes it easier to read oopses when gcc doesn't inline ever static
> > (which it normally does if it only has a single caller)
> 
> Yes. Gcc inlining is a total piece of sh*t.

The static inlining by default (unfortunately) saves a lot of text size.

For testing I built an x86-64 allyesconfig kernel with 
-fno-inline-functions-called-once (which disables the default static
inlining), and it increased text size by ~4.1% (over 2MB for a allyesconfig 
kernel). So I think we have to keep that, dropping it would cost too
much :/

-Andi

-- 
ak@linux.intel.com
