Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZAJGBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZAJGBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZAJGBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:01:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJGBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:01:39 -0500
Message-ID: <496838E7.5020608@zytor.com>
Date: Fri, 09 Jan 2009 21:57:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
       Sven Dietrich <SDietrich@novell.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>  <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>  <20090109204103.GA17212@elte.hu>  <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>  <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>  <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>  <20090109231227.GA25070@elte.hu>  <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>  <20090110010125.GA31031@elte.hu> <1231549697.5700.7.camel@brick> <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain> <49682C05.7030407@zytor.com> <alpine.LFD.2.00.0901092119100.6528@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901092119100.6528@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> And quite often, some of them go away - or at least shrink a lot - when 
> some config option or other isn't set. So sometimes it's an inline because 
> a certain class of people really want it inlined, simply because for 
> _them_ it makes sense, but when you enable debugging or something, it 
> absolutely explodes.
> 

And this is really why getting static inline annotations right is really
hard if not impossible in the general case (especially when considering
the sheer number of architectures we compile on.)  So making it possible
for the compiler to do the right thing for at least this class of
functions really does seem like a good idea.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

