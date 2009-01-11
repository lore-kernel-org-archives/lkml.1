Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZAKR66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZAKR66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZAKR6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:58:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZAKR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:58:45 -0500
Date: Sun, 11 Jan 2009 19:13:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090111181307.GM26290@one.firstfloor.org>
References: <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org> <1231676801.25018.150.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231676801.25018.150.camel@macbook.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:26:41PM +0000, David Woodhouse wrote:
>   - Unconditionally have 'inline' meaning 'always_inline'. If we say it,
>     we should mean it.
> 
>   - Resist the temptation to use -fno-inline-functions. Allow GCC to
>     inline other things if it wants to.

The proposal was to use -fno-inline-functions-called-once (but 
the resulting numbers were not promising)

We've never allowed gcc to inline any other functions not marked
inline explicitely because that's not included in -O2. 

>   - Reduce the number of unnecessary 'inline' markers, and have a policy
>     that the use of 'inline' should be accompanied by either a GCC PR#
>     or an explanation of why we couldn't reasonably have expected GCC to
>     get this particular case right.
> 
>   - Have a similar policy of PR# or explanation for 'uninline' too.
> 
> I don't think we should just give up on GCC ever getting it right. That
> way lies madness. As we've often found in the past. 

It sounds like you're advocating to set -O3/-finline-functions
by default.   Not sure that's a good idea.

-Andi

-- 
ak@linux.intel.com
