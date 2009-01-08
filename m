Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZAHGiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZAHGiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAHGie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:38:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZAHGid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:38:33 -0500
Date: Thu, 8 Jan 2009 07:52:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Message-ID: <20090108065235.GX496@one.firstfloor.org>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231368870.6686.16.camel@norville.austin.ibm.com> <alpine.LFD.2.00.0901071518570.3057@localhost.localdomain> <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about memory hotplug as Ingo mentioned?
> 
> Should that be:
> 
> #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_MEMORY_HOTPLUG)

We expect memory hotunplug to only really work in movable zones
(all others should at least have one kernel object somewhere that prevents
unplug) and you can't have task structs in movable zones obviously

So it's probably a non issue in practice.

-Andi
-- 
ak@linux.intel.com
