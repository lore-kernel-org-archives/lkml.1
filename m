Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZAINGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZAINGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZAINFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:05:51 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:56575 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZAINFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:05:50 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20090109033531.GR496@one.firstfloor.org>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick>
	 <4966ABF9.9080409@zytor.com>  <20090109033531.GR496@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 08:05:02 -0500
Message-Id: <1231506302.21333.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49674B83.0129:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 04:35 +0100, Andi Kleen wrote:
> On Thu, Jan 08, 2009 at 05:44:25PM -0800, H. Peter Anvin wrote:
> > Harvey Harrison wrote:
> > >>
> > >> We might still try the second or third options, as i think we shouldnt go 
> > >> back into the business of managing the inline attributes of ~100,000 
> > >> kernel functions.
> > > 
> > > Or just make it clear that inline shouldn't (unless for a very good reason)
> > > _ever_ be used in a .c file.
> > > 
> > 
> > The question is if that would produce acceptable quality code.  In
> > theory it should, but I'm more than wondering if it really will.
> 
> I actually often use noinline when developing code simply because it 
> makes it easier to read oopses when gcc doesn't inline ever static
> (which it normally does if it only has a single caller). You know
> roughly where it crashed without having to decode the line number.
> 
> I believe others do that too, I notice it's all over btrfs for example.

For btrfs it was mostly about stack size at first.  I'd use
checkstack.pl and then run through the big funcs and figure out how they
got so huge.  It was almost always because gcc was inlining something it
shouldn't, so I started using it on most funcs.

-chris


