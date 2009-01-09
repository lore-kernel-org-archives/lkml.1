Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZAIDVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZAIDVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 22:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZAIDVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 22:21:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47820 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZAIDVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 22:21:21 -0500
Date: Fri, 9 Jan 2009 04:35:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20090109033531.GR496@one.firstfloor.org>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick> <4966ABF9.9080409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4966ABF9.9080409@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 05:44:25PM -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> >>
> >> We might still try the second or third options, as i think we shouldnt go 
> >> back into the business of managing the inline attributes of ~100,000 
> >> kernel functions.
> > 
> > Or just make it clear that inline shouldn't (unless for a very good reason)
> > _ever_ be used in a .c file.
> > 
> 
> The question is if that would produce acceptable quality code.  In
> theory it should, but I'm more than wondering if it really will.

I actually often use noinline when developing code simply because it 
makes it easier to read oopses when gcc doesn't inline ever static
(which it normally does if it only has a single caller). You know
roughly where it crashed without having to decode the line number.

I believe others do that too, I notice it's all over btrfs for example.

-Andi

-- 
ak@linux.intel.com
