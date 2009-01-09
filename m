Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbZAIWBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbZAIWBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbZAIV7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:59:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:31347 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698AbZAIV7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:59:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nl7kS389gSkDpRJBJAn8qkjOG1J8zz7XgjsmGeWPcy4ID9pa4GUPR8Biba5ro2O4Ne
         A28J4jaCGj6fPkhXpAVYbTOqjNk5L1gSMi4Tj44BSi085PU0RNNQwtfsT+GZbPaZ+24P
         DJrmMRIPfmXQL10aJYlJpCDeMywakXq5rG3pQ=
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
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
In-Reply-To: <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org>
	 <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>
	 <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
	 <20090109204103.GA17212@elte.hu>
	 <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
	 <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>
	 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 13:59:47 -0800
Message-Id: <1231538387.5825.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 13:50 -0800, Linus Torvalds wrote:
> 
> On Fri, 9 Jan 2009, Harvey Harrison wrote:
> > 
> > __needs_inline?  That would imply that it's for correctness reasons.
> 
> .. but the point is, we have _thousands_ of inlines, and do you know which 
> is which? We've historically forced them to be inlined, and every time 
> somebody does that "OPTIMIZE_INLINE=y", something simply _breaks_.
> 

My suggestion was just an alternative to __force_inline as a naming...I agree that
inline should mean __always_inline.....always.

> So instead of just continually hitting our head against this wall because 
> some people seem to be convinced that gcc can do a good job, just do it 
> the other way around. Make the new one be "inline_hint" (no underscores 
> needed, btw), and there is ansolutely ZERO confusion about what it means. 

agreed.

> At that point, everybody knows why it's there, and it's clearly not a 
> correctness issue or anything else.
> 
> Of course, at that point you might as well argue that the thing should not 
> exist at all, and that such a flag should just be removed entirely. Which 
> I certainly agree with - I think the only flag we need is "inline", and I 
> think it should mean what it damn well says.

Also agreed, but there needs to start being some education about _not_ using
inline so much in the kernel.

Harvey

