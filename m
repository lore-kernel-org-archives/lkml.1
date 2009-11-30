Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZK3H5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZK3H5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZK3H5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:57:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:33017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbZK3H5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:57:40 -0500
Date: Mon, 30 Nov 2009 08:57:46 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130075746.GJ17484@wotan.suse.de>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091129185122.GE6883@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091129185122.GE6883@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 10:51:22AM -0800, Paul E. McKenney wrote:
> On Sat, Nov 28, 2009 at 09:30:18AM -0800, Linus Torvalds wrote:
> > So as far as I can tell, we have only one real user of rwlocks where 
> > livelocks might be relevant, but that one real user absolutely _requires_ 
> > the unfair behavior.
> 
> But the required unfairness is limited to unconditionally granting
> recursive read requests, right?  If I understand correctly, if a given
> CPU does not already read-hold the lock, then we can safely make that
> CPU wait for a writer that might otherwise be starved.  Again, is there
> another requirement that I am missing?

I think this is the only ordering requirement.

