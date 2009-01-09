Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZAIVvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZAIVvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZAIVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:51:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207AbZAIVvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:51:35 -0500
Date: Fri, 9 Jan 2009 13:50:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
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
In-Reply-To: <1231537320.5726.2.camel@brick>
Message-ID: <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>  <1231434515.14304.27.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>  <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org>
  <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>  <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>  <20090109204103.GA17212@elte.hu>  <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>  <20090109213442.GA20051@elte.hu>
 <1231537320.5726.2.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Harvey Harrison wrote:
> 
> __needs_inline?  That would imply that it's for correctness reasons.

.. but the point is, we have _thousands_ of inlines, and do you know which 
is which? We've historically forced them to be inlined, and every time 
somebody does that "OPTIMIZE_INLINE=y", something simply _breaks_.

So instead of just continually hitting our head against this wall because 
some people seem to be convinced that gcc can do a good job, just do it 
the other way around. Make the new one be "inline_hint" (no underscores 
needed, btw), and there is ansolutely ZERO confusion about what it means. 

At that point, everybody knows why it's there, and it's clearly not a 
correctness issue or anything else.

Of course, at that point you might as well argue that the thing should not 
exist at all, and that such a flag should just be removed entirely. Which 
I certainly agree with - I think the only flag we need is "inline", and I 
think it should mean what it damn well says.

		Linus
