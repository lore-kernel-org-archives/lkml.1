Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbZAJBHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbZAJBHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZAJBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:07:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbZAJBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:07:24 -0500
Date: Fri, 9 Jan 2009 17:06:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
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
In-Reply-To: <20090110010125.GA31031@elte.hu>
Message-ID: <alpine.LFD.2.00.0901091705410.6528@localhost.localdomain>
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu>
 <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Jan 2009, Ingo Molnar wrote:
> 
> Well, it's not totally meaningless. To begin with, defining 'inline' to 
> mean 'always inline' is a Linux kernel definition. So we already changed 
> the behavior - in the hope of getting it right most of the time and in the 
> hope of thus improving the kernel.

Umm. No we didn't. We've never changed it. It was "always inline" back in 
the old days, and then we had to keep it "always inline", which is why we 
override the default gcc meaning with the preprocessor.

Now, OPTIMIZE_INLINING _tries_ to change the semantics, and people are 
complaining..

		Linus
