Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbZATTug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbZATTug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZATTuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:50:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:47700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZATTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:50:20 -0500
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
 implement adaptive spinning
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
In-Reply-To: <20090120123824.GD7790@elte.hu>
References: <20090112005228.GS26290@one.firstfloor.org>
	 <496B86B5.3090707@t-online.de>
	 <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
	 <20090112193201.GA23848@one.firstfloor.org>
	 <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain>
	 <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu>
	 <20090119062212.GC22584@wotan.suse.de>
	 <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
	 <20090120005124.GD16304@wotan.suse.de>  <20090120123824.GD7790@elte.hu>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 06:49:00 +1100
Message-Id: <1232480940.22233.1435.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 13:38 +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > > it seems like a nice opt-in thing that can be used where the aliases 
> > > > are verified and the code is particularly performance critical...
> > > 
> > > Yes. I think we could use it in the kernel, although I'm not sure how 
> > > many cases we would ever find where we really care.
> > 
> > Yeah, we don't tend to do a lot of intensive data processing, so it is 
> > normally the cache misses that hurt most as you noted earlier.
> > 
> > Some places it might be appropriate, though. It might be nice if it can 
> > bring code size down too...
> 
> I checked, its size effects were miniscule [0.17%] on the x86 defconfig 
> kernel and it seems to be a clear loss in total cost as there would be an 
> ongoing maintenance cost

They were talking about 'restrict', not strict-aliasing. Where it can be
used, it's going to give you optimisations that strict-aliasing can't.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

