Return-Path: <linux-kernel-owner+w=401wt.eu-S1765156AbZAOSRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765156AbZAOSRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761178AbZAOSRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:17:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761007AbZAOSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:17:33 -0500
Date: Thu, 15 Jan 2009 10:16:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
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
In-Reply-To: <20090115180844.GL22472@elte.hu>
Message-ID: <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>
 <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain> <20090115180844.GL22472@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Jan 2009, Ingo Molnar wrote:
> 
> btw., i think spin-mutexes have a design advantage here: in a lot of code 
> areas it's quite difficult to use spinlocks - cannot allocate memory, 
> cannot call any code that can sporadically block (but does not _normally_ 
> block), etc.
> 
> With mutexes those atomicity constraints go away - and the performance 
> profile should now be quite close to that of spinlocks as well.

Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
hold the lock over all those unnecessary and complex operations.

IOW, if you do pre-allocation instead of holding a lock over the 
allocation, you win. So yes, spin-mutexes makes it easier to write the 
code, but it also makes it easier to just plain be lazy.

			Linus
