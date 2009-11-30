Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZK3QU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZK3QU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZK3QU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:20:56 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58778 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZK3QUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:20:55 -0500
Date: Mon, 30 Nov 2009 08:20:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130162058.GA6762@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130075557.GI17484@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 08:55:57AM +0100, Nick Piggin wrote:
> On Sat, Nov 28, 2009 at 09:30:18AM -0800, Linus Torvalds wrote:
> > So as far as I can tell, we have only one real user of rwlocks where 
> > livelocks might be relevant, but that one real user absolutely _requires_ 
> > the unfair behavior.
> 
> Yes, although the behaviour required is that it can be recursively
> acquired. So we could still have a lock that disallows new non recursive
> read acquires when there is a pending write locker.
> 
> RCU seems nicer, but tasklist lock locking scares me so I wanted to fix
> it the easy way :)

Having a livelock-free tasklist lock would certainly make it easier
to apply things like RCU on a code-path-by-code-path basis as needed.
Much less scary than a big-bang rip-and-replace.

							Thanx, Paul
