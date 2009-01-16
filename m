Return-Path: <linux-kernel-owner+w=401wt.eu-S934532AbZAPAyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532AbZAPAyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZAPAx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:53:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37708 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbZAPAxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:53:53 -0500
Date: Thu, 15 Jan 2009 16:53:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090116005351.GD6763@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain> <20090115180844.GL22472@elte.hu> <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 10:16:53AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 15 Jan 2009, Ingo Molnar wrote:
> > 
> > btw., i think spin-mutexes have a design advantage here: in a lot of code 
> > areas it's quite difficult to use spinlocks - cannot allocate memory, 
> > cannot call any code that can sporadically block (but does not _normally_ 
> > block), etc.
> > 
> > With mutexes those atomicity constraints go away - and the performance 
> > profile should now be quite close to that of spinlocks as well.
> 
> Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
> hold the lock over all those unnecessary and complex operations.
> 
> IOW, if you do pre-allocation instead of holding a lock over the 
> allocation, you win. So yes, spin-mutexes makes it easier to write the 
> code, but it also makes it easier to just plain be lazy.

In infrequently invoked code such as some error handling, lazy/simple
can be a big win.

							Thanx, Paul
